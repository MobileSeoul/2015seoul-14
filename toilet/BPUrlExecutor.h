//
// Created by kyungtaek on 15. 9. 9..
// Copyright (c) 2015 bezierpaths. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BPUrlExecutor : NSObject

+ (BPUrlExecutor *)instance;

- (BOOL)canHandleUrl:(NSURL *)url;
- (BOOL)handleUrl:(NSURL *)url;


@end