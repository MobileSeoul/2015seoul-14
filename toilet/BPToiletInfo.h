//
//  BPToiletInfo.h
//  toilet
//
//  Created by kyungtaek on 2015. 8. 20..
//  Copyright (c) 2015년 bezierpaths. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef NS_ENUM (NSUInteger, BPPriorityType) {
    BPPriorityTypeRating,
    BPPriorityTypeDistance,
};

@interface BPToiletInfo : NSObject

@property (nonatomic, strong) NSNumber *sn;
@property (nonatomic, assign, readonly) CLLocationCoordinate2D coordinate;

@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, strong) NSNumber *rankAverage;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *options;
@property (nonatomic, strong) NSNumber *diff;
@property (nonatomic, strong) NSString *address;

@property (nonatomic, strong) NSNumber *openningHour;
@property (nonatomic, strong) NSNumber *closeHour;
@property (nonatomic, assign) BOOL allHoursOpen;
@property (nonatomic, assign) NSUInteger statusCode;
@property (nonatomic, strong) NSNumber *rankCount;
@property (nonatomic, strong) NSArray *photoURLs;
@property (nonatomic, strong) NSArray *comments;
@property (nonatomic, strong) NSString *telNumber;
@property (nonatomic, strong) NSString *memo;

@property (nonatomic, strong) NSDate *lastModifiedDate;
@property (nonatomic, strong) NSDictionary *responseRawDic;

@end


@interface BPToiletInfo (API)

+ (BPToiletInfo *)toiletInfoWithDictionary:(NSDictionary *)dic;
+ (NSArray *)parseToiletInfoFromDictionaries:(NSArray *)infoDictionaries;

@end


@interface BPToiletInfo (Helper)

- (NSUInteger) getMeterFromLocation:(CLLocationCoordinate2D)location;

@end

@interface BPToiletInfo (Option)

+ (NSArray *)defaultOptions;
+ (NSString *)localizedStringWithOptionKey:(NSString *)optionKey;

- (NSArray *)parseToiletOptionWithJSONString:(NSString *)jsonString;
- (NSString *)generateToiletOptionWithJSONWithOptions:(NSArray *)options;

@end


@interface BPToiletInfoComment : NSObject

@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, strong) NSNumber *rank;

@end
