//
// Created by kyungtaek on 15. 8. 28..
// Copyright (c) 2015 bezierpaths. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BPURLSessionManager : NSObject

@property (nonatomic, readonly) NSURLSession *apiSession;

+ (BPURLSessionManager *)instance;

@end