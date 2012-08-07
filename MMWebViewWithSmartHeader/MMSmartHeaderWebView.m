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
@synthesize headerView;
@synthesize pinHeader = _pinHeader;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://michaelmanesh.com"]]];
    
    [self.webView.scrollView setDelegate:self];
    [self.webView setDelegate:self];
    
    UIView *newHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320., 70)];
    newHeader.backgroundColor = [UIColor darkGrayColor];
    self.headerView = newHeader;
    
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(self.headerView.frame.size.height, 0.0f, 0.0f, 0.0f);
    self.headerView.frame = CGRectMake(0, 0, self.headerView.frame.size.width, -self.headerView.frame.size.height);
    [self.webView.scrollView addSubview:self.headerView];

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
    
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(70., 0.0f, 0.0f, 0.0f);
    
    if (newValue == YES) {
        // if the header is only partially visible or not at all, we need to animate it into place right away
        if (numberOfPointsOfHeaderVisible < self.headerView.frame.size.height) {
            [UIView animateWithDuration:0.2 animations:^ {
                CGRect headerFrame = self.headerView.frame;
                headerFrame.origin.y = MAX(-70, self.webView.scrollView.contentOffset.y);
                self.headerView.frame = headerFrame;
                self.webView.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(MAX(70, -self.webView.scrollView.contentOffset.y), 0, 0, 0);
            }];
        }
    }
    
    // pinHeader == NO, move back to original position, reset scroll indicator positions
    else {
        [UIView animateWithDuration:0.2 animations:^ {
            self.headerView.frame = CGRectMake(0, 0, self.headerView.frame.size.width, -self.headerView.frame.size.height);
            float bottomOfHeaderView = MAX(0, -self.webView.scrollView.contentOffset.y);
            self.webView.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(bottomOfHeaderView, 0, 0, 0);
        }];
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
        headerFrame.origin.y = MAX(-70, scrollView.contentOffset.y);
        self.headerView.frame = headerFrame;
        self.webView.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(MAX(70, -scrollView.contentOffset.y), 0, 0, 0);
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
