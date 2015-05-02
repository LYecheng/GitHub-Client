//
//  AllIssueTableViewController.m
//  GitHub Issues
//
//  Created by Yecheng Li on 02/01/15.
//  Copyright (c) 2015 Yecheng Li. All rights reserved.
//

#import "AllIssueTableViewController.h"
#import "AllIssueTableViewCell.h"

@interface AllIssueTableViewController ()

@property (strong, nonatomic) NSMutableArray *allIssueData;

@end


@implementation AllIssueTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.allIssueData = [[NSMutableArray alloc] init];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIRefreshControl *pullToRefresh = [[UIRefreshControl alloc] init];
    //pullToRefresh.tintColor = [UIColor megentaColor];
    [pullToRefresh addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = pullToRefresh;
}

- (void) viewDidAppear:(BOOL)animated {
    // Download Github issue data
    [self downloadIssueData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Reference: http://uchicago.mobi/sessions/session4/index.html

- (void) downloadIssueData {
    // GitHub API url
    NSString *url = @"https://api.github.com/repos/uchicago-mobi/2015-Winter-Forum/issues?state=all";
    
    // Create NSUrlSession
    NSURLSession *session = [NSURLSession sharedSession];
    
    // Create data download taks
    [[session dataTaskWithURL:[NSURL URLWithString:url]
            completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
                
                NSError *jsonError;
                self.allIssueData = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:&jsonError];
                // Log the data for debugging
                NSLog(@"DownloadeData:%@",self.allIssueData);
                
                // Use dispatch_async to update the table on the main thread
                // Remember that NSURLSession is downloading in the background
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    
                    if (self.refreshControl.refreshing) {
                        [self.refreshControl endRefreshing];
                    }
                });
            }] resume];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.allIssueData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AlllIssueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"allIssueCell" forIndexPath:indexPath];
    
    // Configure the cell...
    // State = all
    NSLog(@"Working on cell: %ld", (long)indexPath.row);
    NSDictionary *issue = [self.allIssueData objectAtIndex:indexPath.row];
    cell.cellTitle2.text = [issue objectForKey:@"title"];
    cell.cellAuthor2.text = [[issue objectForKey:@"user"] objectForKey:@"login"];
    cell.cellDate2.text = [issue objectForKey:@"updated_at"];
    
    NSString *currentState = [issue objectForKey:@"state"];
    if ([currentState  isEqual: @"open"]) {
        cell.cellImage2.image = [UIImage imageNamed:@"unresolved.png"];
    } else {
        cell.cellImage2.image = [UIImage imageNamed:@"resolved.png"];
    }
    return cell;
}

- (void)refreshAction {
    NSLog(@"Pull to refresh action");
    
    // Requery GitHub API
    [self downloadIssueData];
}

@end

