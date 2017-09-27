//
// Created by kyungtaek on 2015. 10. 29..
// Copyright (c) 2015 bezierpaths. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+BPAddition.h"


@implementation UIImage (BPAddition)

- (UIImage *)bp_scaleImageToSize:(CGSize)newSize {

    CGRect scaledImageRect = CGRectZero;

    CGFloat aspectWidth = newSize.width / self.size.width;
    CGFloat aspectHeight = newSize.height / self.size.height;
    CGFloat aspectRatio = MIN ( aspectWidth, aspectHeight );

    scaledImageRect.size.width = self.size.width * aspectRatio;
    scaledImageRect.size.height = self.size.height * aspectRatio;
    scaledImageRect.origin.x = (newSize.width - scaledImageRect.size.width) / 2.0f;
    scaledImageRect.origin.y = (newSize.height - scaledImageRect.size.height) / 2.0f;

    UIGraphicsBeginImageContextWithOptions( newSize, NO, 0 );
    [self drawInRect:scaledImageRect];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return scaledImage;

}

- (UIImage *)bp_changeColor:(UIColor *)color {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color setFill];
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextClipToMask(context, CGRectMake(0, 0, self.size.width, self.size.height), [self CGImage]);
    CGContextFillRect(context, CGRectMake(0, 0, self.size.width, self.size.height));

    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return coloredImg;
}


@end