//
// Created by kyungtaek on 2015. 10. 20..
// Copyright (c) 2015 bezierpaths. All rights reserved.
//

#import "UIViewController+BPAddition.h"


@implementation UIViewController (BPAddition)

+ (UIViewController *)bp_currentTopViewController
{
    UIViewController *sViewController = nil;
    sViewController = UIApplication.sharedApplication.delegate.window.rootViewController;

    if ([sViewController respondsToSelector:@selector(rootViewController)]) {
        sViewController = [sViewController performSelector:@selector(rootViewController)];
    }
    if ([sViewController isKindOfClass:[UITabBarController class]]) {
        sViewController = [(UITabBarController *)sViewController selectedViewController];
    }
    if ([sViewController isKindOfClass:[UINavigationController class]]) {
        sViewController = [(UINavigationController *)sViewController topViewController];
    }

    while ([sViewController presentedViewController]) {
        sViewController = [sViewController presentedViewController];

        if ([sViewController isKindOfClass:[UINavigationController class]]) {
            sViewController = [(UINavigationController *)sViewController topViewController];
        }
    }

    return sViewController;
}

@end