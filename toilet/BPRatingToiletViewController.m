//
//  BPRatingToiletViewController.m
//  toilet
//
//  Created by kyungtaek on 2015. 8. 27..
//  Copyright (c) 2015년 bezierpaths. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import <HCSStarRatingView/HCSStarRatingView.h>
#import "BPRatingToiletViewController.h"
#import "UIAlertView+BlocksKit.h"
#import "BPToiletInfo.h"
#import "BPDefineUtility.h"
#import "BPFacebookManager.h"
#import "BPToiletReport.h"
#import "FSQCollectionViewAlignedLayout.h"
#import "BPToiletOptionViewCell.h"
#import "JTProgressHUD.h"
#import "BPAPI.h"
#import "UIImage+BPAddition.h"

@interface BPRatingToiletViewController () <UICollectionViewDataSource, FSQCollectionViewDelegateAlignedLayout, UICollectionViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *addresLabel;
@property (weak, nonatomic) IBOutlet UIView *ratingBaseView;
@property (weak, nonatomic) IBOutlet UILabel *ratingScoreLabel;
@property (weak, nonatomic) IBOutlet UIView *zigzagPatternImageView;
@property (weak, nonatomic) HCSStarRatingView *ratingView;
@property (weak, nonatomic) IBOutlet UICollectionView *optionCollectionView;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UILabel *emptyCommentLabel;
@property (weak, nonatomic) IBOutlet UIButton *pickPhotoButton;
@property (strong, nonatomic) BPRatingToiletViewAnimator *animator;

@property(nonatomic, strong) BPToiletReport *report;

@end

@implementation BPRatingToiletViewController
- (instancetype)initWithToiletInfo:(BPToiletInfo *)toiletInfo {
    self = [super init];
    if (self) {
        self.report = [BPToiletReport new];
        [self.report setupWithToiletInfo:toiletInfo];
        self.animator = [BPRatingToiletViewAnimator new];

    }

    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (self.report.userPhoto) {
        [self.pickPhotoButton setTitle:NSLocalizedString(@"사진 변경 또는 삭제", nil) forState:UIControlStateNormal];
    } else {
        [self.pickPhotoButton setTitle:NSLocalizedString(@"사진 추가", nil) forState:UIControlStateNormal];
    }
}


- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillHide:(NSNotification *)notification {

    BP_BLOCK_WEAK wself = self;
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        wself.view.center = CGPointMake(wself.view.center.x, wself.view.center.y + CGRectGetHeight(keyboardFrame));
    }];
}

- (void)keyboardWillShow:(NSNotification *)notification {

    BP_BLOCK_WEAK wself = self;
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    [UIView animateWithDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        wself.view.center = CGPointMake(wself.view.center.x, wself.view.center.y - CGRectGetHeight(keyboardFrame));
    }];

}

- (void)setupView {

    [self.view.layer setCornerRadius:10.f];
    [self.view setClipsToBounds:YES];

    [self.zigzagPatternImageView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"zigzag.png"]]];

    HCSStarRatingView *ratingView = [[HCSStarRatingView alloc] initWithFrame:CGRectZero];
    ratingView.allowsHalfStars = YES;
    ratingView.maximumValue = 5;
    ratingView.minimumValue = 0;
    ratingView.value = [self.report.rankAverage floatValue] == 0.f ? 2.5f : [self.report.rankAverage floatValue];
    ratingView.filledStarImage = [UIImage imageNamed:@"star_color.png"];
    ratingView.emptyStarImage = [UIImage imageNamed:@"star_default.png"];
    [ratingView setBackgroundColor:[UIColor clearColor]];
    [ratingView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.ratingBaseView addSubview:ratingView];
    [self.ratingBaseView addConstraint:[NSLayoutConstraint constraintWithItem:self.ratingBaseView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:ratingView attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    [ratingView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[ratingView(172)]" options:(NSLayoutFormatOptions) 0 metrics:nil views:NSDictionaryOfVariableBindings(ratingView)]];
    [self.ratingBaseView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[ratingScoreLabel]-(9)-[ratingView(28)]" options:(NSLayoutFormatOptions) 0 metrics:nil views:@{@"ratingView":ratingView, @"ratingScoreLabel": self.ratingScoreLabel}]];
    self.ratingView = ratingView;

    [self.optionCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BPToiletOptionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:[BPToiletOptionViewCell cellIdentifier]];
    [self.optionCollectionView setAllowsMultipleSelection:YES];
    FSQCollectionViewAlignedLayout *layout = (FSQCollectionViewAlignedLayout *) [self.optionCollectionView collectionViewLayout];
    [layout setDefaultCellSize:CGSizeMake(50.f, 50.f)];
    [layout setContentInsets:UIEdgeInsetsMake(0,0,0,0)];
    [layout setDefaultCellAttributes:[FSQCollectionViewAlignedLayoutCellAttributes defaultCellAttributes]];

    [self.addresLabel setText:self.report.name.length ? self.report.name : self.report.address];
    [self.optionCollectionView reloadData];

    [self.pickPhotoButton.layer setCornerRadius:2.5f];
    [self.pickPhotoButton setClipsToBounds:YES];
    
    [self.zigzagPatternImageView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"zigzag.png"]]];

    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    BP_BLOCK_WEAK wself = self;

    void (^afterLoginProcessBlock)(void) = ^{
        [[BPFacebookManager instance] reqeustUserInfo:^(NSString *userID, NSString *userName, BOOL isFemale, NSError *error) {

            dispatch_async(dispatch_get_main_queue(), ^{
                if (!isFemale) {
                    [UIAlertView bk_showAlertViewWithTitle:nil message:NSLocalizedString(@"죄송합니다. 여성만 평가할 수 있습니다.", nil) cancelButtonTitle:NSLocalizedString(@"확인", nil) otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        [wself dismissViewControllerAnimated:YES completion:nil];
                    }];
                }
            });
        }];

    };

    if (![[BPFacebookManager instance] isFBLogined]) {

        UIAlertView *alertView = [UIAlertView bk_showAlertViewWithTitle:nil message:NSLocalizedString(@"평가를 진행하려면 페이스북 로그인을 해주세요.당신의 타임라인에 어떤 글도 남기지 않습니다!", nil) cancelButtonTitle:NSLocalizedString(@"다음에 하기", nil) otherButtonTitles:@[NSLocalizedString(@"로그인", nil)] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex != 1) {
                return;
            }
            [[BPFacebookManager instance] loginWithCompletion:^(BOOL isSuccess, NSError *error) {

                if (!isSuccess || error) {
                    [[UIAlertView bk_showAlertViewWithTitle:nil message:NSLocalizedString(@"페이스북 로그인 중 오류가 발생했습니다.\n다음에 다시 시도해주세요.", nil) cancelButtonTitle:NSLocalizedString(@"확인", nil) otherButtonTitles:nil handler:nil] show];
                    return;
                }

                afterLoginProcessBlock();
            }];

        }];
        [alertView show];

    } else {
        afterLoginProcessBlock();
    }

}


- (IBAction)touchUpCloseButton:(id)sender {

    if (self.commentTextView.isFirstResponder) {
        [self.commentTextView resignFirstResponder];
        BP_BLOCK_WEAK wself = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (1.0f* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [wself dismissViewControllerAnimated:YES completion:nil];
        });
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }

}


- (IBAction)touchUpApplyButton:(id)sender {

    [self.commentTextView resignFirstResponder];
    [JTProgressHUD show];

    self.report.userComment = self.commentTextView.text;
    self.report.userRate = self.ratingView.value;

    BP_BLOCK_WEAK wself = self;
    [BPAPI sendRatingWithReport:self.report completion:^(NSError *error) {

        [JTProgressHUD hide];

        if (error) {
            [UIAlertView bk_showAlertViewWithTitle:nil message:NSLocalizedString(@"에러가 발생하였습니다 다시 시도해주세요", nil) cancelButtonTitle:NSLocalizedString(@"확인", nil) otherButtonTitles:nil handler:nil];
            return;
        }

        [UIAlertView bk_showAlertViewWithTitle:nil message:NSLocalizedString(@"평가해주셔서 감사합니다!", nil) cancelButtonTitle:NSLocalizedString(@"확인", nil) otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            [wself dismissViewControllerAnimated:YES completion:nil];
        }];

    }];
}

- (IBAction)touchUpTapGesture:(UITapGestureRecognizer *)gesture {
    [self resignFirstResponder];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [BPToiletInfo defaultOptions].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    BPToiletOptionViewCell *cell = (BPToiletOptionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:[BPToiletOptionViewCell cellIdentifier] forIndexPath:indexPath];
    NSString *key = [BPToiletInfo defaultOptions][(NSUInteger) indexPath.row];
    [cell setKey:key];

    if ([self.report.userReportingOptions containsObject:key]) {
        [cell setStatus:BPToiletOptionViewCellStatusOn];
    } else {
        [cell setStatus:BPToiletOptionViewCellStatusOff];
    }

    return cell;
}


- (FSQCollectionViewAlignedLayoutSectionAttributes *)collectionView:(UICollectionView *)collectionView
                                                             layout:(FSQCollectionViewAlignedLayout *)collectionViewLayout
                                        attributesForSectionAtIndex:(NSInteger)sectionIndex {
    return [FSQCollectionViewAlignedLayoutSectionAttributes centerCenterAlignment];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.commentTextView resignFirstResponder];

    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    BPToiletOptionViewCell *cell = (BPToiletOptionViewCell *) [collectionView cellForItemAtIndexPath:indexPath];

    if (![self.report.userReportingOptions containsObject:[BPToiletInfo defaultOptions][(NSUInteger) indexPath.row]]) {
        [self.report.userReportingOptions addObject:[BPToiletInfo defaultOptions][(NSUInteger) indexPath.row]];
        [cell setStatus:BPToiletOptionViewCellStatusOn];
    } else {
        [self.report.userReportingOptions removeObject:[BPToiletInfo defaultOptions][(NSUInteger) indexPath.row]];
        [cell setStatus:BPToiletOptionViewCellStatusOff];
    }

}


- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self.animator;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self.animator;
}

+ (instancetype)viewControllerWithToiletInfo:(BPToiletInfo *)toiletInfo {
    BPRatingToiletViewController *viewController = [[BPRatingToiletViewController alloc] initWithToiletInfo:toiletInfo];
    viewController.modalPresentationStyle = UIModalPresentationCustom;
    viewController.transitioningDelegate = viewController;
    return viewController;
}

- (IBAction) touchUpSelectPhotoButton:(id)sender {

    self.report.userPhoto = nil;
    [self.commentTextView resignFirstResponder];

    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;

    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];

    CGFloat resizeRatio = 640.f/MAX(image.size.width, image.size.height);
    UIImage *resizedImage = [image bp_scaleImageToSize:CGSizeMake(image.size.width * resizeRatio, image.size.height * resizeRatio)];
    self.report.userPhoto = resizedImage;

    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)textViewDidChange:(UITextView *)textView {
    [self.emptyCommentLabel setHidden:textView.text.length != 0];
}


@end


@interface BPRatingToiletViewAnimator () <UINavigationControllerDelegate>
@end

@implementation BPRatingToiletViewAnimator

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 1.0f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {

    UIView *containerView = transitionContext.containerView;
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    if ([toVC isKindOfClass:[BPRatingToiletViewController class]]) {

        /**
         * Presenting
         */
        BPRatingToiletViewController *ratingViewController = (BPRatingToiletViewController *) toVC;
        [ratingViewController.view setFrame:containerView.bounds];
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.frame = containerView.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [containerView addSubview:blurEffectView];
        self.blurView = blurEffectView;
        [self.blurView setAlpha:0.f];

        [containerView addSubview:blurEffectView];
        [containerView addSubview:ratingViewController.view];
        ratingViewController.view.center = CGPointMake(CGRectGetMidX(containerView.bounds), CGRectGetMaxY(containerView.bounds) + CGRectGetHeight(containerView.bounds));

        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.f usingSpringWithDamping:0.8f initialSpringVelocity:0.2f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.blurView setAlpha:1.f];
            ratingViewController.view.center = containerView.center;
        } completion:^(BOOL finish){
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];

    } else {

        /**
         * Dismissing
         */
        BPRatingToiletViewController *ratingViewController = (BPRatingToiletViewController *) fromVC;

        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.f usingSpringWithDamping:0.8f initialSpringVelocity:0.2f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            ratingViewController.view.center = CGPointMake(CGRectGetMidX(containerView.bounds), -(CGRectGetHeight(containerView.bounds) * 1.5f));
            [self.blurView setAlpha:0.f];
        } completion:^(BOOL finish){
            [self.blurView removeFromSuperview];
            [ratingViewController.view removeFromSuperview];
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];

    }

}

@end

