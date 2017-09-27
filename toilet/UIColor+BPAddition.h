//
// Created by kyungtaek on 2015. 10. 20..
// Copyright (c) 2015 bezierpaths. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIColor (BPAddition)

+ (UIColor *)bp_randomColor;
+ (UIColor *)bp_greenMintColor;
+ (UIColor *)bp_colorFromHexString:(NSString *)hexString;
+ (UIImage *)bp_imageFromColor:(UIColor *)color;
@end