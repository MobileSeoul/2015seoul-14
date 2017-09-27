//
// Created by kyungtaek on 2015. 10. 11..
// Copyright (c) 2015 bezierpaths. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BPToiletInfo;


@interface BPBookmarkManager : NSObject


+ (BPBookmarkManager *)instance;

- (NSArray *)allBookmarks;
- (void)addBookmark:(BPToiletInfo *)toiletInfo;
- (void)removeBookmark:(BPToiletInfo *)toiletInfo;
- (void)removeAllBookmarks;

@end