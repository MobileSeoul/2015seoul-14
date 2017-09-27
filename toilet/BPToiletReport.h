//
// Created by kyungtaek on 2015. 9. 16..
// Copyright (c) 2015 bezierpaths. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BPToiletInfo.h"

@interface BPToiletReport : BPToiletInfo

@property (nonatomic, assign) float          userRate;
@property (nonatomic, assign) BOOL           isWrongPlace;
@property (nonatomic, strong) NSString       *userComment;
@property (nonatomic, strong) NSMutableArray *userReportingOptions;
@property (nonatomic, strong) UIImage        *userPhoto;

- (void)setupWithToiletInfo:(BPToiletInfo *)info;

@end