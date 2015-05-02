//
//  CircleViewController.m
//  GitHub Issues
//
//  Created by Yecheng Li on 02/01/15.
//  Copyright (c) 2015 Yecheng Li. All rights reserved.
//

#import "CircleViewController.h"
#import "CircleView.h"

@interface CircleViewController ()

@property (strong, nonatomic) NSMutableArray *issueData;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UIView *view;

@property int closedIssue;
@property int openIssue;

@end

@implementation CircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.issueData = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
}

- (void) viewDidAppear:(BOOL)animated {
    [self downloadIssueData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) downloadIssueData {
    // GitHub API url
    NSString *url = @"https://api.github.com/repos/uchicago-mobi/2015-Winter-Forum/issues?state=all";
    
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
                NSLog(@"Downloade Data for circleView:%@",self.issueData);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //[self getStatues];
                    
                    self.openIssue = 0;
                    self.closedIssue = 0;
                    
                    for (NSDictionary *currentIssue in self.issueData) {
                        NSString *status = [currentIssue objectForKey:@"state"];
                        
                        // For debugging
                        NSLog(@"status -- %@", status);
                        
                        // Count number of open & closed issues
                        if ([status isEqual:@"open"]) {
                            self.openIssue++;
                        } else {
                            self.closedIssue++;
                        }
                    }
                    
                    // Print results in lable
                     self.label.text = [NSString stringWithFormat:@"%d Closed\nIssues\n\n\n%d Open\nIssues", self.closedIssue, self.openIssue];
                    
                    // Draw circle accordingly
                    CircleView *drawView = (CircleView *) self.view;
                    drawView.open = self.openIssue;
                    drawView.closed = self.closedIssue;
                    
                    [self.view setNeedsDisplay];
                });
            }] resume];
}

@end
