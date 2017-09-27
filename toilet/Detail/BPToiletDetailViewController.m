//
// Created by kyungtaek on 2015. 10. 20..
// Copyright (c) 2015 bezierpaths. All rights reserved.
//

#import "BPToiletDetailViewController.h"
#import "BPToiletCardView.h"
#import "BPToiletCardCell.h"


@implementation BPToiletDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor clearColor]];
}

+ (instancetype)viewControllerWithCardCell:(BPToiletCardCell *)cardCell {
    BPToiletDetailViewController *viewController = [[BPToiletDetailViewController alloc] init];
    viewController.transitionAnimator = [[BPToiletDetailViewAnimator alloc] init];
    viewController.transitioningDelegate = viewController;
    viewController.modalPresentationStyle = UIModalPresentationCustom;
    viewController.transitionAnimator.cardCell = cardCell;

    return viewController;
}


- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self.transitionAnimator;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self.transitionAnimator;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


@end


@implementation BPToiletDetailViewAnimator

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.5f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {

    UIView *containerView = transitionContext.containerView;
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    if ([toVC isKindOfClass:[BPToiletDetailViewController class]]) {

        /**
         * Presenting
         */
        BPToiletDetailViewController *detailViewController = (BPToiletDetailViewController *) toVC;
        BPToiletCardView *cardView = self.cardCell.cardView;
        CGRect fromFrame = [cardView convertRect:cardView.frame toView:nil];
        CGRect toFrame = [UIScreen mainScreen].bounds;
        toFrame.origin.y = 20.f;
        toFrame.size.height -= 20;

        [cardView removeFromSuperview];
        [containerView addSubview:detailViewController.view];
        [detailViewController.view setHidden:YES];
        [containerView addSubview:cardView];
        [cardView setFrame:fromFrame];
        [cardView layoutIfNeeded];

        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.f usingSpringWithDamping:0.8f initialSpringVelocity:0.2f options:UIViewAnimationOptionCurveEaseOut animations:^{
            [cardView setFrame:toFrame];
            [cardView setIsExpendable:YES];
            [cardView layoutIfNeeded];

        } completion:^(BOOL finish){
            [detailViewController.view setHidden:NO];
            [detailViewController.view addSubview:cardView];
            [cardView setFrame:toFrame];
            detailViewController.cardView = cardView;
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];

    } else {

        /**
         * Dismissing
         */
        BPToiletDetailViewController *detailViewController = (BPToiletDetailViewController *) fromVC;
        BPToiletCardView *cardView = detailViewController.cardView;
        CGRect fromFrame = fromVC.view.bounds;
        fromFrame.origin.y = 20;
        fromFrame.size.height -= 20;
        CGRect toFrame = [self.cardCell.cardBaseView convertRect:self.cardCell.cardBaseView.frame toView:nil];

        [cardView removeFromSuperview];
        [containerView addSubview:cardView];
        [cardView setFrame:fromFrame];
        [cardView layoutIfNeeded];

        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.f usingSpringWithDamping:0.8f initialSpringVelocity:0.2f options:UIViewAnimationOptionCurveEaseOut animations:^{
            [cardView setFrame:toFrame];
            [cardView setIsExpendable:NO];
            [cardView layoutIfNeeded];
        } completion:^(BOOL finish){
            [detailViewController.view removeFromSuperview];
            [self.cardCell.cardBaseView addSubview:cardView];
            [cardView setFrame:self.cardCell.cardBaseView.bounds];
            detailViewController.cardView = nil;
            self.cardCell.cardView = cardView;
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];

    }

}


@end