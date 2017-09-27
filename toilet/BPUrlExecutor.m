//
// Created by kyungtaek on 15. 9. 9..
// Copyright (c) 2015 bezierpaths. All rights reserved.
//

#import "BPUrlExecutor.h"


@implementation BPUrlExecutor {

}
+ (BPUrlExecutor *)instance {
    static BPUrlExecutor *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

- (BOOL)canHandleUrl:(NSURL *)url {

    return [url.host isEqualToString:@"choo-app"];
}

- (BOOL)handleUrl:(NSURL *)url {

    if ([url.path isEqualToString:@"emergency"]) {



        return YES;

    } else if ([url.path isEqualToString:@"rating"]) {

        return YES;
    }

    return NO;
}

@end