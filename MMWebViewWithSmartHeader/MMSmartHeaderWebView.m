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

@property (nonatomic, retain) UIImageView *scrollIndicatorVertical;

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
    /*
    self.webView.scrollView.clipsToBounds = NO;
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(self.headerView.frame.size.height, 0, 0, 0);
    [self.webView.scrollView addSubview:self.headerView];
     */
    
    //[(UIScrollView *) self.view setContentSize: CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(self.headerView.frame.size.height, 0.0f, 0.0f, 0.0f);
    self.headerView.frame = CGRectMake(0, 0, self.headerView.frame.size.width, -self.headerView.frame.size.height);
    [self.webView.scrollView addSubview:self.headerView];
    
    [self.webView.scrollView setScrollsToTop:YES];
    
    //[self.webView.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.webView.scrollView setShowsVerticalScrollIndicator:NO];
    
    UIImage *scrollbar = [UIImage imageNamed:@"scroll-bar.png"];
    self.scrollIndicatorVertical = [[UIImageView alloc] initWithImage:[scrollbar stretchableImageWithLeftCapWidth:0 topCapHeight:5]];
    self.scrollIndicatorVertical.alpha = 0.0;
    [self.webView addSubview:self.scrollIndicatorVertical];
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
    float contentOffset = scrollView.contentOffset.y;
    float contentHeight = scrollView.contentSize.height;
    float numberOfPointsOfHeaderViewVisible = MIN(self.headerView.frame.size.height, self.headerView.frame.size.height - contentOffset);
    float bottomOfHeaderView = MAX(0, - contentOffset);
    float frameHeight = self.webView.frame.size.height;
    
    float maxContentOffset = contentHeight - frameHeight;
    
    // we we interpret content offset values between 0 and maxContentOffset to move the scroll bar around.
    // less than 0 or greater than the maxContentOffset means we are bouncing, and need to use special behavior
    float percentageVisible = frameHeight / scrollView.contentSize.height;
    float scrollBarHeight = percentageVisible * frameHeight;
    float percentageScrolled = contentOffset / maxContentOffset;
    float scrollBarPosition = percentageScrolled * (frameHeight - scrollBarHeight);
    
    self.scrollIndicatorVertical.frame = CGRectMake(312, scrollBarPosition, 7, scrollBarHeight);
    
    // the scrollbar is partially visible, but we are not past it
    if (contentOffset < 0 && contentOffset > -self.headerView.frame.size.height) {
        float percentageVisible = (frameHeight + contentOffset) / scrollView.contentSize.height;
        float scrollBarHeight = percentageVisible * frameHeight;
        self.scrollIndicatorVertical.frame = CGRectMake(312, bottomOfHeaderView, 7, scrollBarHeight);
    }
    // the scrollbar is fully visible, and we are past it and into bounce territory
    // we double the scroll bar's shrinkage rate at this point
    else if (contentOffset <= -self.headerView.frame.size.height) {
        float howMuchPast = contentOffset + self.headerView.frame.size.height;
        float percentageVisible = (frameHeight + contentOffset) / scrollView.contentSize.height;
        float scrollBarHeight = MAX((percentageVisible * frameHeight) + howMuchPast, 8.);
        
        self.scrollIndicatorVertical.frame = CGRectMake(312, bottomOfHeaderView, 7, scrollBarHeight);
    }
    else if (contentOffset >= maxContentOffset) {
        float howMuchPast = maxContentOffset - contentOffset;
        self.scrollIndicatorVertical.frame = CGRectMake(312, MIN(frameHeight-scrollBarHeight-howMuchPast, frameHeight-8.), 7, MAX(scrollBarHeight+howMuchPast, 8.));
    }
    else {
        
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
    
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    NSLog(@"decelerate");
    [UIView animateWithDuration:0.5 delay:.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{ self.scrollIndicatorVertical.alpha = 0; } completion:nil];
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
    
    [self.scrollIndicatorVertical setAlpha:1.];
}


@end
