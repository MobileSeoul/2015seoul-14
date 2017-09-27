//
//  BPToiletMapAnnotation.m
//  toilet
//
//  Created by kyungtaek on 2015. 10. 15..
//  Copyright © 2015년 bezierpaths. All rights reserved.
//

#import "BPToiletMapAnnotation.h"
#import "UIColor+BPAddition.h"
#import "UIImage+BPAddition.h"

@implementation BPToiletMapAnnotation
- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title sn:(NSNumber *)sn {
    self = [super init];
    if (self) {
        _coordinate = coordinate;
        self.title = title;
        self.sn = sn;
    }

    return self;
}

- (MKAnnotationView *)annotationView {

    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"BPToiletMapAnnotation"];
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    annotationView.image = [[UIImage imageNamed:@"pin_toilet.png"] bp_changeColor:[UIColor bp_colorFromHexString:@"#bbbbbb"]];

    return annotationView;
}

@end
