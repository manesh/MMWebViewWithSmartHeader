//
//  MMViewController.m
//  MMWebViewWithSmartHeader
//
//  Created by Michael Manesh on 8/3/12.
//  Copyright (c) 2012 Michael Manesh. All rights reserved.
//

#import "MMSmartHeaderWebView.h"

@interface MMSmartHeaderWebView ()

@property BOOL fingerIsDown;

@end

@implementation MMSmartHeaderWebView
@synthesize webView;
@synthesize headerView;
@synthesize fingerIsDown;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://michaelmanesh.com"]]];
    
    [self.webView.scrollView setDelegate:self];
    
    //[(UIScrollView *) self.view setContentSize: CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    
    //self.webView.scrollView.contentInset = UIEdgeInsetsMake(self.headerView.frame.size.height, 0.0f, 0.0f, 0.0f);
    //self.headerView.frame = CGRectMake(0, 0, self.headerView.frame.size.width, -self.headerView.frame.size.height);
    //[self.webView.scrollView addSubview:self.headerView];

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
    
    NSLog(@"%f", contentOffset);
    
    // case A: we are pushing up, hiding the header view and increasing the size of the webview.
    if(contentOffset > 0.0) {
        
        NSLog(@"A");
        
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
            //self.webView.scrollView.contentOffset = CGPointZero;
            
            // in theory, we need to take any "remainder" offset and apply it to the webview for a perfectly smooth transition.
            // for instance, if there's 10 points of header showing and the view scrolls 20 points in one step, the
            // header's offset should be set to 10. In practice, it doesn't make a difference.
        }
        
    }
    
    // case B: we are pulling down, possibly revealing the header.
    else if (contentOffset < 0.0) {
        
        NSLog(@"B");
        
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
            //self.webView.scrollView.contentOffset = CGPointZero;
        }
        
        // the header is already fully visible, but we keep pushing down, we want to forward events to the enclosing scroll view
        else {
            if (fingerIsDown) {
                
                NSLog(@"E");
                
                UIScrollView *scrollViewWrapper = (UIScrollView *)self.view;
                
                // scroll the scrollView
                [scrollViewWrapper setContentOffset:CGPointMake(0, scrollViewWrapper.contentOffset.y + contentOffset)];
                
                // adjust the size of the web view.
                CGRect webFrame = self.webView.frame;
                webFrame.size.height = webView.frame.size.height + contentOffset;
                self.webView.frame = webFrame;
                
                // keep the webview from scrolling
                self.webView.scrollView.contentOffset = CGPointZero;
            }
            // finger isn't down, but we may need to adjust
            else {
                

                
                        NSLog(@"D");
                
                // adjust the size of the web view.
                /*
                CGRect webFrame = self.webView.frame;
                webFrame.origin.y = self.headerView.frame.size.height + self.headerView.frame.origin.y;
                webFrame.size.height = MIN(self.view.frame.size.height - webFrame.origin.y, self.view.frame.size.height);
                self.webView.frame = webFrame;
                 */

                
                // keep the webview from scrolling
                //self.webView.scrollView.contentOffset = CGPointZero;
            }
        }
    }
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    fingerIsDown = NO;
    
    // adjust the size of the web view.
    CGRect webFrame = self.webView.frame;
    webFrame.size.height = MAX(self.view.frame.size.height - self.headerView.frame.size.height, self.webView.frame.size.height);
    self.webView.frame = webFrame;
    
    NSLog(@"willEndDragging: velocity: %f, targetContentOffset: %f", velocity.y, targetContentOffset->y);
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    UIScrollView *scrollViewWrapper = (UIScrollView *)self.view;
    
    // scroll the scrollView
    [scrollViewWrapper setContentOffset:CGPointMake(0, 0) animated:YES];
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    NSLog(@"decelerate");
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSLog(@"animation finished");
}

-(void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    NSLog(@"scroll to top");
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"scrolling will begin");
    fingerIsDown = YES;
}


@end
