//
//  AppDelegate.m
//  toilet
//
//  Created by kyungtaek on 2015. 8. 20..
//  Copyright (c) 2015년 bezierpaths. All rights reserved.
//

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "AppDelegate.h"
#import "BPRootViewController.h"
#import "BPToiletListViewController.h"
#import "BPIntroViewController.h"
#import "BPRatingToiletViewController.h"
#import "BPSetting.h"
#import "BPDefineUtility.h"
#import "UIViewController+BPAddition.h"
#import "UIColor+BPAddition.h"
#import "BPAPI.h"
#import "BPToiletReport.h"
#import "BPLocationManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];

    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    [[UIApplication sharedApplication] registerForRemoteNotifications]; // you can also set
    [BPLocationManager instance];

    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [window setTintColor:[UIColor bp_greenMintColor]];
    self.window = window;

    if ([[BPSetting instance] alreadyShownIntro]) {

        [self setupRootViewController];
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [self launchRatingViewControllerIfNeeds];

    } else {
        [self setupIntroViewController];
    }

    [self.window makeKeyAndVisible];

    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {

    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                 openURL:url
                                                       sourceApplication:sourceApplication
                                                              annotation:annotation];

    return handled;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
    application.applicationIconBadgeNumber = 0;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [self launchRatingViewControllerIfNeeds];
}

- (void) setupRootViewController {
    BPRootViewController *rootViewController = [[BPRootViewController alloc] initWithRootViewController:[[BPToiletListViewController alloc] init]];

    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    window.rootViewController = rootViewController;
    [[UIApplication sharedApplication].delegate setWindow:window];

    [window makeKeyAndVisible];
}


- (void)setupIntroViewController {

    BP_BLOCK_WEAK wself = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[BPIntroViewController alloc] initWithCompletion:^{
        [wself setupRootViewController];
    }]];
    [navigationController setNavigationBarHidden:YES];
    self.window.rootViewController = navigationController;
}


- (void)launchRatingViewControllerIfNeeds {

    BPToiletInfo *toiletInfo = [[BPSetting instance] currentInterestingToiletInfo];
    if (!toiletInfo) {
        return;
    }

    [[BPSetting instance] setCurrentInterestingToiletInfo:nil];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[UIViewController bp_currentTopViewController] presentViewController:[BPRatingToiletViewController viewControllerWithToiletInfo:toiletInfo] animated:YES completion:nil];
    });
}



@end
