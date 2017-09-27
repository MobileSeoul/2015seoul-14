//
//  BPToiletInfo.m
//  toilet
//
//  Created by kyungtaek on 2015. 8. 20..
//  Copyright (c) 2015년 bezierpaths. All rights reserved.
//

#import "BPToiletInfo.h"

@implementation BPToiletInfo

- (CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
}

@end



@implementation BPToiletInfo (API)


+ (BPToiletInfo *)toiletInfoWithDictionary:(NSDictionary *)dic {

    BPToiletInfo *info = [BPToiletInfo new];
    info.sn = @([dic[@"sn"] integerValue]);
    info.latitude = @([dic[@"langitude"] doubleValue]);
    info.longitude = @([dic[@"longitude"] doubleValue]);
    info.rankAverage = @([dic[@"rankAvg"] floatValue]);
    info.name = dic[@"name"];
    info.options = dic[@"jsonData"];
    info.diff = @([dic[@"diff"] floatValue]);
    info.address = dic[@"addr"];
    info.openningHour = @([dic[@"openningHour"] integerValue]);
    info.closeHour = @([dic[@"closeHour"] integerValue]);
    info.allHoursOpen = [dic[@"allHoursOpen"] boolValue];
    info.statusCode = (NSUInteger) [dic[@"status"] integerValue];
    info.rankCount = @([dic[@"rankCnt"] integerValue]);

    NSMutableArray *photoURLs = [NSMutableArray new];
    [dic[@"photoData"] enumerateObjectsUsingBlock:^(NSString *photoURLString, NSUInteger idx, BOOL *stop) {
        [photoURLs addObject:[NSURL URLWithString:photoURLString]];
    }];
    info.photoURLs = [NSArray arrayWithArray:photoURLs];

    NSMutableArray *comments = [NSMutableArray new];
    [dic[@"comment"] enumerateObjectsUsingBlock:^(NSDictionary *commentDic, NSUInteger idx, BOOL *stop) {
        BPToiletInfoComment *newComment = [BPToiletInfoComment new];
        newComment.comment = commentDic[@"comment"];
        newComment.rank = commentDic[@"rank"];
        newComment.creationDate = [NSDate dateWithTimeIntervalSince1970:[commentDic[@"regTimestamp"] doubleValue]];

        if (newComment.comment.length == 0) {
            return;
        }

        [comments addObject:newComment];
    }];
    info.comments = [NSArray arrayWithArray:comments];

    info.telNumber = dic[@"tel"];
    info.memo = dic[@"memo"];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    info.lastModifiedDate = [dateFormatter dateFromString:dic[@"lastModified"]];

    info.responseRawDic = dic;

    return info;

}

+ (NSArray *)parseToiletInfoFromDictionaries:(NSArray *)infoDictionaries {

    NSMutableArray *list = [NSMutableArray new];
    [infoDictionaries enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL *stop) {
        [list addObject:[BPToiletInfo toiletInfoWithDictionary:dic]];
    }];

    return list;
}


@end



@implementation BPToiletInfo (Helper)

- (NSUInteger)getMeterFromLocation:(CLLocationCoordinate2D)location {

    CLLocation *infoLocation = [[CLLocation alloc] initWithLatitude:self.coordinate.latitude longitude:self.coordinate.longitude];
    CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];

    CLLocationDistance distance = [currentLocation distanceFromLocation:infoLocation];
    return (NSUInteger) distance;
}

@end


@implementation BPToiletInfo (Option)

+ (NSArray *)defaultOptions {
    return @[
            @"tissue",      //@"휴지",
            @"seat",        //@"양변기",
            @"seat2",       //@"좌변기",
            @"soap",        //@"비누",
            @"child",       //@"유아동반",
            @"bidet",       //@"비데",
            @"unisex",      //@"남여공용",
            @"doorlock",    //@"도어락",
            @"powder",      //@"파우더룸",
            @"disabled",    //@"장애인전용"
    ];
}

+ (NSString *)localizedStringWithOptionKey:(NSString *)optionKey {

    if ([optionKey isEqual:@"tissue"  ]) return NSLocalizedString(@"tissue",  nil);
    if ([optionKey isEqual:@"seat"    ]) return NSLocalizedString(@"seat",    nil);
    if ([optionKey isEqual:@"seat2"    ])return NSLocalizedString(@"seat2",    nil);
    if ([optionKey isEqual:@"soap"    ]) return NSLocalizedString(@"soap",    nil);
    if ([optionKey isEqual:@"child"   ]) return NSLocalizedString(@"child",   nil);
    if ([optionKey isEqual:@"bidet"   ]) return NSLocalizedString(@"bidet",   nil);
    if ([optionKey isEqual:@"unisex"  ]) return NSLocalizedString(@"unisex",  nil);
    if ([optionKey isEqual:@"doorlock"]) return NSLocalizedString(@"doorlock",nil);
    if ([optionKey isEqual:@"powder"  ]) return NSLocalizedString(@"powder",  nil);
    if ([optionKey isEqual:@"disabled"]) return NSLocalizedString(@"disabled",nil);

    return nil;
}

- (NSArray *)parseToiletOptionWithJSONString:(NSString *)jsonString {
    NSError *parseError = nil;
    NSArray *parseData = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&parseError];
    return parseData;
}

- (NSString *)generateToiletOptionWithJSONWithOptions:(NSArray *)options {

    if (!options) {
        return @"";
    }

    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:options options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    return jsonString;
}


@end


@implementation BPToiletInfoComment


@end