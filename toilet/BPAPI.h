//
// Created by kyungtaek on 2015. 9. 16..
// Copyright (c) 2015 bezierpaths. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BPToiletInfo.h"

@class BPToiletReport;


@interface BPAPI : NSObject

+ (NSURLSessionTask *)fetchToiletInfoWithCurrentLocation:(CLLocationCoordinate2D)currentLocation priority:(BPPriorityType)priorityType filterOptions:(NSArray *)filterOptions completion:(void (^)(NSArray *toiletList, NSError *error))completion;

+ (NSURLSessionTask *)sendRatingWithReport:(BPToiletReport *)report completion:(void (^)(NSError *error))completion;



@end