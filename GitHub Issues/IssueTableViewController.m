//
//  IssueTableViewController.m
//  GitHub Issues
//
//  Created by Yecheng Li on 02/01/15.
//  Copyright (c) 2015 Yecheng Li. All rights reserved.
//

#import "IssueTableViewController.h"
#import "IssueDetailViewController.h"
#import "IssueTableViewCell.h"

@interface IssueTableViewController ()

@property (strong, nonatomic) NSMutableArray *issueData;

@end

@implementation IssueTableViewController

- (IBAction)unwindSegue:(UIStoryboardSegue *)segue {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.issueData = [[NSMutableArray alloc] init];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
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
    NSString *url = @"https://api.github.com/repos/uchicago-mobi/2015-Winter-Forum/issues?state=open";
    
    // Create NSUrlSession
    NSURLSession *session = [NSURLSession sharedSession];
    
    // Create data download taks
    [[session dataTaskWithURL:[NSURL URLWithString:url]
            completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
                
                NSError *jsonError;
                self.issueData = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:&jsonError];
                // Log the data for debugging
                NSLog(@"DownloadeData:%@",self.issueData);
                
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
    return [self.issueData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IssueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"issueCell" forIndexPath:indexPath];
    
    // Configure the cell...
    // State = open
    NSLog(@"Working on cell: %ld", (long)indexPath.row);
    NSDictionary *issue = [self.issueData objectAtIndex:indexPath.row];
    
    cell.title.text = [issue objectForKey:@"title"];
    cell.author.text = [[issue objectForKey:@"user"] objectForKey:@"login"];
    cell.date.text = [issue objectForKey:@"updated_at"];
    cell.image.image = [UIImage imageNamed:@"unresolved.png"];
    
    return cell;
}

- (void)refreshAction {
    NSLog(@"Pull to refresh action");
    
    // Requery GitHub API
    [self downloadIssueData];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"segueIssueDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *issue = [self.issueData objectAtIndex:indexPath.row];
        IssueDetailViewController *idvc = [segue destinationViewController];
        [idvc setCurrentIssue:issue];
    }
}


@end
