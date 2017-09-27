//
//  BPRatingToiletViewController.h
//  toilet
//
//  Created by kyungtaek on 2015. 8. 27..
//  Copyright (c) 2015년 bezierpaths. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HCSStarRatingView;
@class BPToiletInfo;

@interface BPRatingToiletViewController : UIViewController <UIViewControllerTransitioningDelegate>

+ (instancetype)viewControllerWithToiletInfo:(BPToiletInfo *)toiletInfo;

@end

@interface BPRatingToiletViewAnimator : NSObject <UIViewControllerAnimatedTransitioning>
@property(nonatomic, weak) UIVisualEffectView *blurView;
@end
