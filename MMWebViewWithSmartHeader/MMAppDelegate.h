//
//  MMAppDelegate.h
//  MMWebViewWithSmartHeader
//
//  Created by Michael Manesh on 8/3/12.
//  Copyright (c) 2012 Michael Manesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMSmartHeaderWebView;

@interface MMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MMSmartHeaderWebView *viewController;

@end
