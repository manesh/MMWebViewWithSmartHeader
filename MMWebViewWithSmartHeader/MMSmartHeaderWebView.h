//
//  MMViewController.h
//  MMWebViewWithSmartHeader
//
//  Created by Michael Manesh on 8/3/12.
//  Copyright (c) 2012 Michael Manesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMSmartHeaderWebView : UIWebView {
    
}

@property (strong, nonatomic) UIView *headerView;

// set this to pin/unpin the header to be always visible. includes an animation into / out of sight if at an appopriate scroll position
@property BOOL pinHeader;

- (id)initWithFrame:(CGRect)newFrame header:(UIView *)header;

@end
