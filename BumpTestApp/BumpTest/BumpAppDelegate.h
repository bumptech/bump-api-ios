//
//  BumpAppDelegate.h
//  BumpTest
//
//  Created by Thomas Greany on 1/26/12.
//  Copyright (c) 2012 Bump Technologies, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BumpViewController;

@interface BumpAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) BumpViewController *viewController;

@end
