//
//  IssueDetailViewController.m
//  GitHub Issues
//
//  Created by Yecheng Li on 02/01/15.
//  Copyright (c) 2015 Yecheng Li. All rights reserved.
//

#import "IssueDetailViewController.h"

@interface IssueDetailViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *safariButton;

@end

@implementation IssueDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    self.cellTitle.text = [self.currentIssue objectForKey:@"title"];
    self.cellContent.text = [self.currentIssue objectForKey:@"body"];
    self.cellAuthor.text = [[self.currentIssue objectForKey:@"user"] objectForKey:@"login"];
    self.cellDate.text = [self.currentIssue objectForKey:@"updated_at"];    
}

- (IBAction)browseInSafari:(id)sender {
    NSLog(@"browsing safari");
    
    NSString *urlString =[self.currentIssue objectForKey:@"html_url"];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
        NSLog(@"Opened current issue in Safari");
    }
}



@end
