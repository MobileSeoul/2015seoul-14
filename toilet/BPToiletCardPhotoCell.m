//
//  BPToiletCardPhotoCell.m
//  toilet
//
//  Created by kyungtaek on 2015. 10. 19..
//  Copyright © 2015년 bezierpaths. All rights reserved.
//

#import "BPToiletCardPhotoCell.h"
#import "UIColor+BPAddition.h"
#import "UIImageView+WebCache.h"

@implementation BPToiletCardPhotoCell

+ (NSString *)cellIdentifier {
    return NSStringFromClass([self class]);
}

- (void)awakeFromNib {

    [self.layer setBorderWidth:1.f];
    [self.layer setBorderColor:[UIColor bp_colorFromHexString:@"#d9d9d9"].CGColor];

}

- (void)prepareForReuse {
    [self.imageView sd_cancelCurrentImageLoad];
    [self.imageView setImage:nil];
    [self setIsLoaded:NO];
}


@end
