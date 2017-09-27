//
// Created by kyungtaek on 15. 9. 1..
// Copyright (c) 2015 bezierpaths. All rights reserved.
//

#import <FBSDKCoreKit/FBSDKGraphRequest.h>
#import <FBSDKLoginKit/FBSDKLoginManagerLoginResult.h>
#import "BPFacebookManager.h"
#import "FBSDKAccessToken.h"
#import "BPDefineUtility.h"
#import "BPSetting.h"
#import "FBSDKLoginManager.h"
#import "FBSDKProfile.h"

@implementation BPFacebookManager
+ (BPFacebookManager *)instance {
    static BPFacebookManager *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loginWithCompletion:(void (^)(BOOL isSuccess, NSError *error))completion {

    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    BP_BLOCK_WEAK wself = self;
    [login logInWithReadPermissions:@[@"public_profile"]  handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            BP_RUN_BLOCK(completion, NO, error);
        } else if (result.isCancelled) {
            BP_RUN_BLOCK(completion, NO, nil);
        } else {
            BP_RUN_BLOCK(completion, YES, nil);
        }
    }];

}

- (void)reqeustUserInfo:(void (^)(NSString *userID, NSString *userName, BOOL isFemale, NSError *error))completion {

    if (![self isFBLogined]) {
        return;
    }

    BP_BLOCK_WEAK wself = self;
    NSDictionary *params = @{@"fields":@"id,gender,name"};
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:params] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            BOOL isFemaleUser = [result[@"gender"] isEqual:@"female"];
            BP_RUN_BLOCK(completion, result[@"id"], result[@"name"], isFemaleUser, nil);
            [[BPSetting instance] setIsFemaleUser:isFemaleUser];
        } else {
            BP_RUN_BLOCK(completion, nil, nil, NO, error);
        }
    }];


}

- (BOOL)isFBLogined {
    FBSDKAccessToken *accessToken = [FBSDKAccessToken currentAccessToken];
    return accessToken != nil;
}


@end