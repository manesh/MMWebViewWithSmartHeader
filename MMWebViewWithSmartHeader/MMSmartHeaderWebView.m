//
//  MMViewController.m
//  MMWebViewWithSmartHeader
//
//  Created by Michael Manesh on 8/3/12.
//  Copyright (c) 2012 Michael Manesh. All rights reserved.
//

#import "MMSmartHeaderWebView.h"

@interface MMSmartHeaderWebView ()

@end

@implementation MMSmartHeaderWebView
@synthesize webView;
@synthesize headerView = _headerView;
@synthesize pinHeader;

- (void)setHeaderView:(UIView *)newHeaderView {
    
    _headerView = newHeaderView;
    
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(self.headerView.frame.size.height, 0.0f, 0.0f, 0.0f);
    self.headerView.frame = CGRectMake(0, 0, self.headerView.frame.size.width, -self.headerView.frame.size.height);
    [self.webView.scrollView addSubview:self.headerView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://michaelmanesh.com"]]];
    
    [self.webView.scrollView setDelegate:self];
    [self.webView setDelegate:self];
    
    UIView *newHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320., 70)];
    newHeader.backgroundColor = [UIColor darkGrayColor];
    self.headerView = newHeader;

}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [self setHeaderView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float bottomOfHeaderView = MAX(0, -scrollView.contentOffset.y);
    self.webView.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(bottomOfHeaderView, 0, 0, 0);
    
    // anchor the header at the top of the screen
    if (pinHeader) {
        CGRect headerFrame = self.headerView.frame;
        headerFrame.origin.y = MAX(0, -scrollView.contentOffset.y - self.headerView.frame.size.height);
        self.headerView.frame = headerFrame;
        
        [self.view addSubview:self.headerView];
    }
}

@end
