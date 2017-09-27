//
// Created by kyungtaek on 2015. 9. 16..
// Copyright (c) 2015 bezierpaths. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "BPAPI.h"
#import "BPToiletReport.h"
#import "BPURLSessionManager.h"
#import "BPDefineUtility.h"


@implementation BPAPI

+ (NSURLSessionTask *)fetchToiletInfoWithCurrentLocation:(CLLocationCoordinate2D)currentLocation priority:(BPPriorityType)priorityType filterOptions:(NSArray *)filterOptions completion:(void (^)(NSArray *toiletList, NSError *error))completion {

    NSString *requestURLString = [NSString stringWithFormat:@"http://diytour.me/choo/Toilet/getList/%@/%f/%f", priorityType == BPPriorityTypeRating ? @"rank" : @"pos", currentLocation.latitude, currentLocation.longitude];

    NSURLSessionTask *task = [[BPURLSessionManager instance].apiSession dataTaskWithURL:[NSURL URLWithString:requestURLString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            BP_RUN_BLOCK(completion, nil, error);
            return;
        }

        NSError *parseError = nil;
        NSArray *parsedData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&parseError];
        NSArray *toiletInfos = nil;
        if (!parseError && parsedData) {
            toiletInfos = [BPToiletInfo parseToiletInfoFromDictionaries:parsedData];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            BP_RUN_BLOCK(completion, toiletInfos, parseError);
        });

    }];
    [task resume];

    return task;
}

+ (NSURLSessionTask *)sendRatingWithReport:(BPToiletReport *)report completion:(void (^)(NSError *error))completion {

    NSString *boundary = @"----WebKitFormBoundaryxt0MKpj8Ybh98Ww5";

    NSString *requestURLString = [NSString stringWithFormat:@"http://diytour.me/choo/Toilet/review"];

    NSMutableData *body = [NSMutableData new];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"toiletSn"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", report.sn] dataUsingEncoding:NSUTF8StringEncoding]];

    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"rank"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%f\r\n", report.userRate] dataUsingEncoding:NSUTF8StringEncoding]];

    if (report.userComment) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"comment"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", report.userComment] dataUsingEncoding:NSUTF8StringEncoding]];
    }

    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"jsonData"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",  [report generateToiletOptionWithJSONWithOptions:report.userReportingOptions]] dataUsingEncoding:NSUTF8StringEncoding]];

    if (report.userPhoto) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", @"photo"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        NSData *userPhotoData = UIImageJPEGRepresentation(report.userPhoto, 0.7f);
        [body appendData:userPhotoData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }

    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURLString]];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:body];

    NSURLSessionTask *task = [[BPURLSessionManager instance].apiSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        dispatch_async(dispatch_get_main_queue(), ^{
            BP_RUN_BLOCK(completion, error);
        });
    }];

    [task resume];

    return task;
}

@end