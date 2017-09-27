//
// Created by kyungtaek on 15. 8. 28..
// Copyright (c) 2015 bezierpaths. All rights reserved.
//

#import "BPURLSessionManager.h"

const NSUInteger BPURLSessionManagerMaxConnectionCount = 10;
const NSUInteger BPURLSessionManagerMaxResourceTimeout = 60;
const NSUInteger BPURLSessionManagerMaxRequestTimeout = 30;

@interface BPURLSessionManager () <NSURLSessionDelegate>

@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) NSURLSession *apiSession;

@end

@implementation BPURLSessionManager


+ (BPURLSessionManager *)instance {
    static BPURLSessionManager *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

- (instancetype) init {
    self = [super init];

    if(self) {
        self.operationQueue = [[NSOperationQueue alloc] init];
        self.operationQueue.name = @"bezierpaths.wafp.sessionQueue";
        self.operationQueue.maxConcurrentOperationCount = BPURLSessionManagerMaxConnectionCount;
        [self setupSessions];
    }

    return self;
}

- (void) setupSessions {

    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    [sessionConfiguration setHTTPMaximumConnectionsPerHost:BPURLSessionManagerMaxConnectionCount];
    [sessionConfiguration setTimeoutIntervalForResource:BPURLSessionManagerMaxResourceTimeout];
    [sessionConfiguration setTimeoutIntervalForRequest:BPURLSessionManagerMaxRequestTimeout];

    self.apiSession = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:self.operationQueue];

}

@end