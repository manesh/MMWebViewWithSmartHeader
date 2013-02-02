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

@synthesize headerView;

@synthesize pinHeader = _pinHeader;

- (id)initWithFrame:(CGRect)newFrame header:(UIView *)header {
    if(self = [super init]) {

        self.frame = newFrame;
        
        self.headerView = header;
        
        [self.scrollView setDelegate:self];

        self.scrollView.contentInset = UIEdgeInsetsMake(self.headerView.frame.size.height, 0.0f, 0.0f, 0.0f);
        self.headerView.frame = CGRectMake(0, 0, self.headerView.frame.size.width, -self.headerView.frame.size.height);
        [self.scrollView addSubview:self.headerView];
    }
    
    return self;
}

- (void)setPinHeader:(BOOL)newValue {
    
    float numberOfPointsOfHeaderVisible = MAX(0, -self.scrollView.contentOffset.y);
    
    if (newValue == YES) {
        // if the header is only partially visible or not at all, we need to animate it into place right away
        if (numberOfPointsOfHeaderVisible < self.headerView.frame.size.height) {
            [UIView animateWithDuration:0.2 animations:^ {
                CGRect headerFrame = self.headerView.frame;
                headerFrame.origin.y = MAX(-self.headerView.frame.size.height, self.scrollView.contentOffset.y);
                self.headerView.frame = headerFrame;
                self.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(MAX(self.headerView.frame.size.height, -self.scrollView.contentOffset.y), 0, 0, 0);
            }];
        }
    }
    
    // pinHeader == NO, move back to original position, reset scroll indicator positions
    else {
        [UIView animateWithDuration:0.2 animations:^ {
            self.headerView.frame = CGRectMake(0, 0, self.headerView.frame.size.width, -self.headerView.frame.size.height);
            float bottomOfHeaderView = MAX(0, -self.scrollView.contentOffset.y);
            self.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(bottomOfHeaderView, 0, 0, 0);
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
    self.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(bottomOfHeaderView, 0, 0, 0);
    
    // anchor the header at the top of the screen
    if (_pinHeader) {
        CGRect headerFrame = self.headerView.frame;
        headerFrame.origin.y = MAX(-self.headerView.frame.size.height, scrollView.contentOffset.y);
        self.headerView.frame = headerFrame;
        self.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(MAX(self.headerView.frame.size.height, -scrollView.contentOffset.y), 0, 0, 0);
    }
	
	// keep header anchored within the view
	CGRect frame = self.headerView.frame;
	frame.origin.x = scrollView.contentOffset.x;
	self.headerView.frame = frame;
}

@end
