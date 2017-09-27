//
// Created by kyungtaek on 2015. 9. 16..
// Copyright (c) 2015 bezierpaths. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BPToiletReport.h"
#import "BPUserInfo.h"


@implementation BPToiletReport {

}

- (void)setupWithToiletInfo:(BPToiletInfo *)info {

    self.sn = info.sn;
    self.address = info.address;
    self.name = info.name;
    self.userReportingOptions = [NSMutableArray arrayWithArray:info.options];
    self.userComment = @"";
    self.rankAverage = info.rankAverage;

}
@end