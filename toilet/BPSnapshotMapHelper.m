//
// Created by kyungtaek on 15. 9. 11..
// Copyright (c) 2015 bezierpaths. All rights reserved.
//

#import "BPSnapshotMapHelper.h"
#import "BPDefineUtility.h"
#import <MapKit/MapKit.h>

@implementation BPSnapshotMapHelper {

}
+ (BPSnapshotMapHelper *)instance {
    static BPSnapshotMapHelper *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}


- (void)requestMapImageWithCoordinate:(CLLocationCoordinate2D)coordinate targetSize:(CGSize)targetSize completion:(void (^)(UIImage *image, NSError *error))completion {

    MKMapSnapshotOptions * snapOptions = [[MKMapSnapshotOptions alloc] init];
    CLLocation * Location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(Location.coordinate, 1, 1);
    snapOptions.size = targetSize;
    snapOptions.scale = [[UIScreen mainScreen] scale];

    MKMapSnapshotter * mapSnapShot = [[MKMapSnapshotter alloc] initWithOptions:snapOptions];

    [mapSnapShot startWithCompletionHandler:^(MKMapSnapshot *snapshot, NSError *error) {

        UIImage *image = nil;
        if (snapshot.image) {
            image = snapshot.image;
        }
        BP_RUN_BLOCK(completion, image, error);

    }];

}

@end