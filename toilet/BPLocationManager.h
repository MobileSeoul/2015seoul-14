//
// Created by kyungtaek on 15. 8. 28..
// Copyright (c) 2015 bezierpaths. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class BPToiletInfo;

typedef void (^BPLocationManagerUpdateLocationBlock)(CLLocation *currentLocation, NSString *name, NSError *error);

@interface BPLocationManager : NSObject

+ (BPLocationManager *)instance;
- (void)requestCurrentLocationWithCompletion:(BPLocationManagerUpdateLocationBlock)completion;
- (void)stopRequestCurrentLocation;

- (void)fetchAutocompleteLocation:(NSString *)query completion:(void (^)(NSArray *LocationList, NSError *error))completion;
- (void)fetchCoordinateFromGooglePlaceID:(NSString *)placeID completion:(void (^)(CLLocationCoordinate2D coordinate2D, NSError *error))completion;

- (void)registerGeofenceNotificationWithToiletInfo:(BPToiletInfo *)toiletInfo;
- (void)removeAllGeofenceNotification;

@end