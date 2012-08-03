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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://michaelmanesh.com"]]];
    
    [self.webView.scrollView setDelegate:self];
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
    
    float numberOfPointsOfHeaderViewVisible = self.headerView.frame.size.height + self.headerView.frame.origin.y;
    float contentOffset = scrollView.contentOffset.y;
    
    // case A: we are pushing up, hiding the header view and increasing the size of the webview.
    if(contentOffset > 0.0) {
        
        // if the header is still visible at all
        if (numberOfPointsOfHeaderViewVisible > 0.0) {
            
            // push the header up.
            float newHeaderPositionY = self.headerView.frame.origin.y - contentOffset;
            CGRect headerFrame = self.headerView.frame;
            headerFrame.origin.y = MAX(newHeaderPositionY, -self.headerView.frame.size.height);
            self.headerView.frame = headerFrame;
            
            // adjust the size of the web view.
            CGRect webFrame = self.webView.frame;
            webFrame.origin.y = self.headerView.frame.size.height + self.headerView.frame.origin.y;
            webFrame.size.height = MIN(self.view.frame.size.height - webFrame.origin.y, self.view.frame.size.height);
            self.webView.frame = webFrame;
            
            // keep the webview from scrolling
            self.webView.scrollView.contentOffset = CGPointZero;
            
            // in theory, we need to take any "remainder" offset and apply it to the webview for a perfectly smooth transition.
            // for instance, if there's 10 points of header showing and the view scrolls 20 points in one step, the
            // header's offset should be set to 10. In practice, it doesn't make a difference.
        }
        
    }
    
    // case B: we are pulling down, possibly revealing the header.
    else if (contentOffset < 0.0) {
        
        // bring the header into view if it's not already fully visible
        if (numberOfPointsOfHeaderViewVisible < self.headerView.frame.size.height) {
            
            // push the header down.
            float newHeaderPositionY = self.headerView.frame.origin.y - contentOffset;
            CGRect headerFrame = self.headerView.frame;
            headerFrame.origin.y = MIN(newHeaderPositionY, 0);
            self.headerView.frame = headerFrame;
            
            // adjust the size of the web view.
            CGRect webFrame = self.webView.frame;
            webFrame.origin.y = self.headerView.frame.size.height + self.headerView.frame.origin.y;
            webFrame.size.height = MIN(self.view.frame.size.height - webFrame.origin.y, self.view.frame.size.height);
            self.webView.frame = webFrame;
            
            // keep the webview from scrolling
            self.webView.scrollView.contentOffset = CGPointZero;
        }
  

    }
    
}

@end
