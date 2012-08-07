//
//  RootViewController.h
//  MMWebViewWithSmartHeader
//
//  Created by Michael Manesh on 8/6/12.
//  Copyright (c) 2012 Michael Manesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *headerView;

- (IBAction)backAction:(id)sender;
- (IBAction)pinAction:(id)sender;
- (IBAction)unpinAction:(id)sender;

@end
