//
// Created by kyungtaek on 15. 9. 11..
// Copyright (c) 2015 bezierpaths. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface BPSnapshotMapHelper : NSObject

+ (BPSnapshotMapHelper *)instance;
- (void)requestMapImageWithCoordinate:(CLLocationCoordinate2D)coordinate targetSize:(CGSize)targetSize completion:(void (^)(UIImage *image, NSError *error))completion;


@end