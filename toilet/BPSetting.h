//
//  BPSetting.h
//  toilet
//
//  Created by kyungtaek on 2015. 8. 22..
//  Copyright (c) 2015년 bezierpaths. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BPToiletInfo;

@interface BPSetting : NSObject

@property(nonatomic, assign) BOOL alreadyShownIntro;
@property(nonatomic, assign) BOOL isFemaleUser;
@property(nonatomic, strong) BPToiletInfo *currentInterestingToiletInfo;

+ (BPSetting *)instance;

@end
