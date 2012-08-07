//
//  RootViewController.m
//  MMWebViewWithSmartHeader
//
//  Created by Michael Manesh on 8/6/12.
//  Copyright (c) 2012 Michael Manesh. All rights reserved.
//

#import "RootViewController.h"
#import "MMSmartHeaderWebView.h"

@interface RootViewController ()

@property (nonatomic, retain) MMSmartHeaderWebView *smartView;

@end

@implementation RootViewController
@synthesize headerView;
@synthesize smartView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.smartView = [[MMSmartHeaderWebView alloc] initWithFrame:self.view.frame header:self.headerView];
    [self.view addSubview:smartView.webView];
    [smartView.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString: @"http://michaelmanesh.com"]]];
}

- (void)viewDidUnload
{
    [self setHeaderView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)backAction:(id)sender {
    [self.smartView.webView goBack];
}

- (IBAction)pinAction:(id)sender {
    self.smartView.pinHeader = YES;
}

- (IBAction)unpinAction:(id)sender {
    self.smartView.pinHeader =  NO;
}

@end
