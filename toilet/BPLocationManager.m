//
// Created by kyungtaek on 15. 8. 28..
// Copyright (c) 2015 bezierpaths. All rights reserved.
//

#import "BPLocationManager.h"
#import "BPDefineUtility.h"
#import "BPToiletInfo.h"
#import <GoogleMaps.h>

static NSString *BPLocationManagerGoogleAPIKey = @"AIzaSyBEmIniTFn8Qg7_ys_XLPd_PW7DHo_fbi0";

@interface BPLocationManager() <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLGeocoder *geoCoder;

@property (nonatomic, copy) BPLocationManagerUpdateLocationBlock completion;

@end


@implementation BPLocationManager

- (instancetype)init {
    self = [super init];
    if(self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = kCLDistanceFilterNone; //whenever we move
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.geoCoder = [[CLGeocoder alloc] init];
        [self.locationManager requestWhenInUseAuthorization];
        [GMSServices provideAPIKey:BPLocationManagerGoogleAPIKey];
    }

    return self;
}

+ (BPLocationManager *)instance {
    static BPLocationManager *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}


- (void)requestCurrentLocationWithCompletion:(BPLocationManagerUpdateLocationBlock)completion {
    self.completion = completion;
    [self.locationManager startUpdatingLocation];
}

- (void)stopRequestCurrentLocation {
    [self.locationManager stopUpdatingLocation];
}

- (void)fetchAutocompleteLocation:(NSString *)query completion:(void (^)(NSArray *LocationList, NSError *error))completion {

    GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
    filter.type = kGMSPlacesAutocompleteTypeFilterNoFilter;

    [[GMSPlacesClient sharedClient] autocompleteQuery:query bounds:nil filter:filter callback:^(NSArray *results, NSError *error) {
        if (error != nil) {
            NSLog(@"Autocomplete error %@", [error localizedDescription]);
            return;
        }

        NSMutableArray *convertedLocationList = [NSMutableArray new];
        [results enumerateObjectsUsingBlock:^(GMSAutocompletePrediction *prediction, NSUInteger idx, BOOL *stop) {
            [convertedLocationList addObject:@{@"name":prediction.attributedFullText.string, @"placeID":prediction.placeID}];
        }];

        BP_RUN_BLOCK(completion, convertedLocationList, error);
    }];

}

- (void)fetchCoordinateFromGooglePlaceID:(NSString *)placeID completion:(void (^)(CLLocationCoordinate2D coordinate2D, NSError *error))completion {

    [[GMSPlacesClient sharedClient] lookUpPlaceID:placeID callback:^(GMSPlace *result, NSError *error) {
        BP_RUN_BLOCK(completion, result.coordinate, error);
    }];

}

- (void)registerGeofenceNotificationWithToiletInfo:(BPToiletInfo *)toiletInfo {

    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:toiletInfo.coordinate radius:30 identifier:[NSString stringWithFormat:@"%@", toiletInfo.sn]];
    [self.locationManager startMonitoringForRegion:region];

}

- (void)removeAllGeofenceNotification {
    [self.locationManager.monitoredRegions enumerateObjectsUsingBlock:^(CLRegion *region, BOOL *stop) {
        [self.locationManager stopMonitoringForRegion:region];
    }];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {

    [self.geoCoder reverseGeocodeLocation:locations.lastObject completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error && placemarks.count) {
            BP_RUN_BLOCK(self.completion, locations.lastObject,  ((CLPlacemark *)placemarks.lastObject).name, nil);
        } else {
            BP_RUN_BLOCK(self.completion, locations.lastObject, @"", nil);
        }
    }];
}


- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {

}


@end