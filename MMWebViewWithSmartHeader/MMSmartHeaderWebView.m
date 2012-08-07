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
@synthesize pinHeader = _pinHeader;

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

- (void)setPinHeader:(BOOL)newValue {
    
    float numberOfPointsOfHeaderVisible = MAX(0, -self.webView.scrollView.contentOffset.y);
    
    if (newValue == YES) {
        [self.view addSubview:self.headerView];
        
        // already fully visible, simply set position since it won't seem to move to the user
        if (numberOfPointsOfHeaderVisible >= self.headerView.frame.size.height) {
            CGRect headerFrame = self.headerView.frame;
            headerFrame.origin.y = MAX(0, -self.webView.scrollView.contentOffset.y - self.headerView.frame.size.height);
            self.headerView.frame = headerFrame;
        }
        // partially visible or not at all, animate from current position into view
        else {
            CGRect headerFrame = self.headerView.frame;
            headerFrame.origin.y = -self.headerView.frame.size.height + numberOfPointsOfHeaderVisible;
            self.headerView.frame = headerFrame;
            
            [UIView animateWithDuration:0.2 animations:^ {
                CGRect headerFrame = self.headerView.frame;
                headerFrame.origin.y = MAX(0, -self.webView.scrollView.contentOffset.y - self.headerView.frame.size.height);
                self.headerView.frame = headerFrame;
            }];
        }
    }
    
    // pinHeader == NO
    else {
        //self.webView.scrollView.contentInset = UIEdgeInsetsMake(self.headerView.frame.size.height, 0.0f, 0.0f, 0.0f);
        self.headerView.frame = CGRectMake(0, 0, self.headerView.frame.size.width, -self.headerView.frame.size.height);
        [self.webView.scrollView addSubview:self.headerView];
    }
    
    _pinHeader = newValue;
}

- (BOOL)pinHeader {
    return _pinHeader;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float bottomOfHeaderView = MAX(0, -scrollView.contentOffset.y);
    self.webView.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(bottomOfHeaderView, 0, 0, 0);
    
    // anchor the header at the top of the screen
    if (_pinHeader) {
        CGRect headerFrame = self.headerView.frame;
        headerFrame.origin.y = MAX(0, -scrollView.contentOffset.y - self.headerView.frame.size.height);
        self.headerView.frame = headerFrame;
    }
        
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    self.pinHeader = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.pinHeader = NO;
    

}
@end
