//
// Created by kyungtaek on 2015. 10. 11..
// Copyright (c) 2015 bezierpaths. All rights reserved.
//

#import "BPBookmarkManager.h"
#import "BPToiletInfo.h"


@interface BPBookmarkManager ()

@property (nonatomic, strong) NSMutableArray *allBookmarks;

@end

@implementation BPBookmarkManager

+ (BPBookmarkManager *)instance {
    static BPBookmarkManager *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

- (void)loadBookmarks {

    self.allBookmarks = [NSKeyedUnarchiver unarchiveObjectWithFile:[self archiveFilePath]];
    if (!self.allBookmarks) {
        self.allBookmarks = [NSMutableArray new];
    }
}

- (void)saveBookmarks {

    [NSKeyedArchiver archiveRootObject:self.allBookmarks toFile:[self archiveFilePath]];

}

- (NSString *)archiveFilePath {

    NSString      *cachesDirectory = (NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES))[0];
    NSString      *cachesPath = [cachesDirectory stringByAppendingPathComponent:@"com.bezierpaths.choo"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError       *error;
    BOOL           isDirectory = NO;
    BOOL           isFile = [fileManager fileExistsAtPath:cachesPath isDirectory:&isDirectory];

    if (isFile) {
        if (isDirectory) {
            return cachesPath;
        } else {
            [fileManager removeItemAtPath:cachesPath error:&error];
            [fileManager createDirectoryAtPath:cachesPath withIntermediateDirectories:YES attributes:nil error:&error];
        }
    } else {
        [fileManager createDirectoryAtPath:cachesPath withIntermediateDirectories:YES attributes:nil error:&error];
    }


    return [NSString stringWithFormat:@"%@/bookmarks.data", cachesPath];
}


- (void)addBookmark:(BPToiletInfo *)toiletInfo {

    [self saveBookmarks];
}

- (void)removeBookmark:(BPToiletInfo *)toiletInfo {

    [self saveBookmarks];
}

- (void)removeAllBookmarks {

    [_allBookmarks removeAllObjects];
    [self saveBookmarks];
}


@end