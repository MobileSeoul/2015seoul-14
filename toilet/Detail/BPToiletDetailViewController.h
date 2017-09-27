//
// Created by kyungtaek on 2015. 10. 20..
// Copyright (c) 2015 bezierpaths. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class BPToiletCardView;
@class BPToiletDetailViewAnimator;
@class BPToiletCardCell;

@interface BPToiletDetailViewController : UIViewController <UIViewControllerTransitioningDelegate>

@property (nonatomic, weak) BPToiletCardView *cardView;
@property (nonatomic, strong) BPToiletDetailViewAnimator *transitionAnimator;

+ (instancetype)viewControllerWithCardCell:(BPToiletCardCell *)cardCell;

@end


@interface BPToiletDetailViewAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, strong) BPToiletCardCell *cardCell;

@end