//
// Created by kyungtaek on 15. 9. 1..
// Copyright (c) 2015 bezierpaths. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BPFacebookManager : NSObject

+ (BPFacebookManager *)instance;

- (void)loginWithCompletion:(void (^)(BOOL isSuccess, NSError *error))completion;
- (void)reqeustUserInfo:(void (^)(NSString *userID, NSString *userName, BOOL isFemale, NSError *error))completion;
- (BOOL)isFBLogined;

@end