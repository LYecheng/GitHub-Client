//
//  IssueDetailViewController.h
//  GitHub Issues
//
//  Created by Yecheng Li on 02/01/15.
//  Copyright (c) 2015 Yecheng Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IssueDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

@property (strong, nonatomic) NSDictionary *currentIssue;

@property (weak, nonatomic) IBOutlet UITextView *cellTitle;
@property (weak, nonatomic) IBOutlet UITextView *cellContent;
@property (weak, nonatomic) IBOutlet UILabel *cellDate;
@property (weak, nonatomic) IBOutlet UILabel *cellAuthor;

- (IBAction)browseInSafari:(id)sender;

@end
