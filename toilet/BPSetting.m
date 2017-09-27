//
//  BPSetting.m
//  toilet
//
//  Created by kyungtaek on 2015. 8. 22..
//  Copyright (c) 2015년 bezierpaths. All rights reserved.
//

#import "BPSetting.h"
#import "FBSDKAccessToken.h"
#import "BPDefineUtility.h"
#import "FBSDKGraphRequest.h"
#import "BPToiletInfo.h"

@implementation BPSetting
+ (BPSetting *)instance {
    static BPSetting *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

- (BOOL)alreadyShownIntro {

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [[userDefaults objectForKey:@"alreadyShownIntro"] boolValue];

}

- (void)setAlreadyShownIntro:(BOOL)alreadyShownIntro {

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@(alreadyShownIntro) forKey:@"alreadyShownIntro"];
    [userDefaults synchronize];
}

- (BOOL)isFemaleUser {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [[userDefaults objectForKey:@"isFemaleUser"] boolValue];

}

- (void)setIsFemaleUser:(BOOL)isFemaleUser {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@(isFemaleUser) forKey:@"isFemaleUser"];
    [userDefaults synchronize];
}


- (BPToiletInfo *)currentInterestingToiletInfo {

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *rawInfo = [userDefaults objectForKey:@"interestingToieltInfo"];

    if (rawInfo) {
        return [BPToiletInfo toiletInfoWithDictionary:rawInfo];
    }

    return nil;
}

- (void)setCurrentInterestingToiletInfo:(BPToiletInfo *)currentInterestingToiletInfo {

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (currentInterestingToiletInfo) {
        [userDefaults setObject:currentInterestingToiletInfo.responseRawDic forKey:@"interestingToieltInfo"];
    } else {
        [userDefaults removeObjectForKey:@"interestingToieltInfo"];
    }
    [userDefaults synchronize];
}


@end
