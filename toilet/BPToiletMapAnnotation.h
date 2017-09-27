//
//  BPToiletMapAnnotation.h
//  toilet
//
//  Created by kyungtaek on 2015. 10. 15..
//  Copyright © 2015년 bezierpaths. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mapkit/Mapkit.h>

@interface BPToiletMapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSNumber *sn;

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title sn:(NSNumber *)sn;

- (MKAnnotationView *)annotationView;


@end
