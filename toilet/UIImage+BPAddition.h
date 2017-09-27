//
// Created by kyungtaek on 2015. 10. 29..
// Copyright (c) 2015 bezierpaths. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage (BPAddition)

- (UIImage *)bp_scaleImageToSize:(CGSize)newSize;
- (UIImage *)bp_changeColor:(UIColor *)color;

@end