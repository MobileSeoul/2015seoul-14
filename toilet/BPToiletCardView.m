//
//  BPToiletCardView.m
//  toilet
//
//  Created by kyungtaek on 2015. 10. 19..
//  Copyright © 2015년 bezierpaths. All rights reserved.
//

#import <BlocksKit/NSTimer+BlocksKit.h>
#import "BPToiletCardView.h"
#import "HCSStarRatingView.h"
#import "BPToiletInfo.h"
#import "BPDefineUtility.h"
#import "BPToiletCardPhotoCell.h"
#import "BPToiletCardCommentCell.h"
#import "UIColor+BPAddition.h"
#import "UIViewController+BPAddition.h"
#import "BPToiletOptionViewCell.h"
#import "NSDate+DateTools.h"
#import "UIImageView+WebCache.h"

@interface BPToiletCardPhoto : NSObject <NYTPhoto>

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, readonly) UIImage *placeholderImage;
@property (nonatomic, readonly) NSAttributedString *attributedCaptionTitle;
@property (nonatomic, readonly) NSAttributedString *attributedCaptionSummary;
@property (nonatomic, readonly) NSAttributedString *attributedCaptionCredit;


@end

@implementation BPToiletCardPhoto

- (UIImage *)placeholderImage {
    return self.image;
}

- (NSAttributedString *)attributedCaptionTitle {
    return [[NSAttributedString alloc] initWithString:@""];
}

- (NSAttributedString *)attributedCaptionSummary {
    return [[NSAttributedString alloc] initWithString:@""];
}

- (NSAttributedString *)attributedCaptionCredit {
    return [[NSAttributedString alloc] initWithString:@""];
}


@end

@implementation BPToiletCardView

- (void)awakeFromNib {
    
    HCSStarRatingView *ratingView = [[HCSStarRatingView alloc] initWithFrame:CGRectZero];
    ratingView.allowsHalfStars = YES;
    ratingView.maximumValue = 5;
    ratingView.minimumValue = 0;
    ratingView.value = 0.f;
    ratingView.userInteractionEnabled = NO;
    ratingView.filledStarImage = [UIImage imageNamed:@"star_color.png"];
    ratingView.emptyStarImage = [UIImage imageNamed:@"star_default.png"];
    [ratingView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.ratingBaseView addSubview:ratingView];
    [self.ratingBaseView addConstraint:[NSLayoutConstraint constraintWithItem:self.ratingBaseView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:ratingView attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    [ratingView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[ratingView(138)]" options:(NSLayoutFormatOptions) 0 metrics:nil views:NSDictionaryOfVariableBindings(ratingView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[ratingCountLabel]-(4)-[ratingView(22)]" options:(NSLayoutFormatOptions) 0 metrics:nil views:@{@"ratingView":ratingView, @"ratingCountLabel":self.ratingCountLabel}]];
    [ratingView setBackgroundColor:[UIColor clearColor]];
    self.ratingView = ratingView;

    [self.optionCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BPToiletOptionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:[BPToiletOptionViewCell cellIdentifier]];
    [self.optionCollectionView setUserInteractionEnabled:NO];
    FSQCollectionViewAlignedLayout *layout = (FSQCollectionViewAlignedLayout *) [self.optionCollectionView collectionViewLayout];
    [layout setDefaultCellSize:CGSizeMake(50.f,50.f)];
    [layout setContentInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [layout setDefaultCellAttributes:[FSQCollectionViewAlignedLayoutCellAttributes defaultCellAttributes]];

    [self.photoCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BPToiletCardPhotoCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:[BPToiletCardPhotoCell cellIdentifier]];
    [self.commentListView registerNib:[UINib nibWithNibName:NSStringFromClass([BPToiletCardCommentCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[BPToiletCardCommentCell cellIdentifier]];
    [self.commentListView setEstimatedRowHeight:60.f];
    [self.commentListView setRowHeight:UITableViewAutomaticDimension];

    [self setIsExpendable:NO];
    [self.zigzagView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"zigzag.png"]]];
}

- (void)setToiletInfo:(BPToiletInfo *)toiletInfo {
    _toiletInfo = toiletInfo;

    [self.ratingCountLabel setText:[NSString stringWithFormat:NSLocalizedString(@"평점 %@점 (%@명 참여)", nil), toiletInfo.rankAverage, toiletInfo.rankCount]];
    [self.ratingView setValue:[toiletInfo.rankAverage floatValue]];
    [self.distanceLabel setText:[NSString stringWithFormat:NSLocalizedString(@"%ld min", nil), (NSUInteger)([toiletInfo getMeterFromLocation:self.currentCoordinate] / 50.f + 1.f)]];
    [self.nameLabel setText:self.toiletInfo.name.length ? self.toiletInfo.name : self.toiletInfo.address];
    [self.simpleOtherContentLabel setText:[NSString stringWithFormat:NSLocalizedString(@"%ld개의 코멘트와 %ld개의 이미지가 있습니다", nil), self.toiletInfo.comments.count, self.toiletInfo.photoURLs.count]];

    [self.photoCollectionView reloadData];
    [self.commentListView reloadData];
    [self.optionCollectionView reloadData];

    [self.emptyCommentLabel setHidden:toiletInfo.comments.count > 0];

}

- (void)cardIndex:(NSUInteger)index total:(NSUInteger)total {
    [self.countingLabel setText:[NSString stringWithFormat:@"%lu/%lu", (unsigned long)index, (unsigned long)total]];
}

- (IBAction)onTouchGetRouteButton:(id)sender {
    BP_RUN_BLOCK(self.handleGetRoute, self.toiletInfo);
}

- (IBAction)onTouchCloseDetailView:(id)sender {
    BP_BLOCK_WEAK wself = self;
    [[UIViewController bp_currentTopViewController] dismissViewControllerAnimated:YES completion:^{
        wself.isExpendable = NO;
    }];
}

- (void)setIsExpendable:(BOOL)isExpendable {
    _isExpendable = isExpendable;

    [self.closeButton setHidden:!isExpendable];
    [self.photoCollectionView setUserInteractionEnabled:isExpendable];

    if (IS_IPHONE_4_OR_LESS || IS_IPHONE_5) {
        [self.optionCollectionViewHeight setConstant:54.f * (isExpendable ? 2: 1)];
    } else {
        [self.optionCollectionViewHeight setConstant:54.f * 2];
    }

    [self.detailCardBaseView setHidden:!isExpendable];
    [self.getRouteButton setHidden:isExpendable];

    if (self.autoRolingTimer) {
        [self.autoRolingTimer invalidate];
        self.autoRolingTimer = nil;
    }

    if (!isExpendable && (IS_IPHONE_4_OR_LESS || IS_IPHONE_5)) {

        self.autoRolingTimer = [NSTimer bk_scheduledTimerWithTimeInterval:4.f block:^(NSTimer *timer) {

            if (self.optionCollectionView.contentOffset.y == 0.f) {
                [self.optionCollectionView setContentOffset:CGPointMake(0, 54.f) animated:YES];
            } else {
                [self.optionCollectionView setContentOffset:CGPointMake(0, 0) animated:YES];
            }

        } repeats:YES];
    }


    [self setNeedsUpdateConstraints];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    if ([collectionView isEqual:self.optionCollectionView]) {
        return [BPToiletInfo defaultOptions].count;
    } else if ([collectionView isEqual:self.photoCollectionView]) {
        return MAX(self.toiletInfo.photoURLs.count, 3);
    } else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    if ([collectionView isEqual:self.optionCollectionView]) {
        BPToiletOptionViewCell *cell = (BPToiletOptionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:[BPToiletOptionViewCell cellIdentifier] forIndexPath:indexPath];

        NSString *defaultOptionKey = [BPToiletInfo defaultOptions][(NSUInteger) indexPath.row];
        [cell setKey:defaultOptionKey];
        if (![self.toiletInfo.options containsObject:defaultOptionKey]) {
            if ([self.toiletInfo.rankCount integerValue] == 0) {
                [cell setStatus:BPToiletOptionViewCellStatusNoData];
            } else {
                [cell setStatus:BPToiletOptionViewCellStatusOff];
            }
        } else {
            [cell setStatus:BPToiletOptionViewCellStatusOn];
        }

        return cell;

    } else if ([collectionView isEqual:self.photoCollectionView]) {
        BPToiletCardPhotoCell *cell = (BPToiletCardPhotoCell *) [collectionView dequeueReusableCellWithReuseIdentifier:[BPToiletCardPhotoCell cellIdentifier] forIndexPath:indexPath];

        if (indexPath.row < self.toiletInfo.photoURLs.count) {
            [cell.imageView sd_setImageWithURL:self.toiletInfo.photoURLs[indexPath.row] placeholderImage:[UIImage imageNamed:@"noimg_icon.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (!error) {
                    cell.isLoaded = YES;
                }
            }];
        } else {
            [cell.imageView setImage:[UIImage imageNamed:@"noimg_icon.png"]];
            cell.isLoaded = NO;
        }

        return cell;
    } else {
        return nil;
    }
}

- (FSQCollectionViewAlignedLayoutSectionAttributes *)collectionView:(UICollectionView *)collectionView
                                                             layout:(FSQCollectionViewAlignedLayout *)collectionViewLayout
                                        attributesForSectionAtIndex:(NSInteger)sectionIndex {
    return [FSQCollectionViewAlignedLayoutSectionAttributes centerCenterAlignment];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if (![collectionView isEqual:self.photoCollectionView]) {
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
        return;
    }

    if (indexPath.row >= self.toiletInfo.photoURLs.count) {
        return;
    }

    NSURL *image  = self.toiletInfo.photoURLs[(NSUInteger) indexPath.row];
    if (image.absoluteString.length == 0) {
        return;
    }


    BPToiletCardPhotoCell *cell = (BPToiletCardPhotoCell *) [collectionView cellForItemAtIndexPath:indexPath];
    if (!cell.isLoaded) {
        return;
    }

    BPToiletCardPhoto *photo = [BPToiletCardPhoto new];
    photo.image = cell.imageView.image;

    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:@[photo]];
    [[UIViewController bp_currentTopViewController] presentViewController:photosViewController animated:YES completion:nil];
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}


#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.toiletInfo.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    BPToiletInfoComment *comment = self.toiletInfo.comments[(NSUInteger) indexPath.row];

    BPToiletCardCommentCell *cell = (BPToiletCardCommentCell *) [tableView dequeueReusableCellWithIdentifier:[BPToiletCardCommentCell cellIdentifier] forIndexPath:indexPath];
    [cell.commentLabel setText:comment.comment];
    [cell.dateLabel setText:[NSString stringWithFormat:@"%@", [comment.creationDate shortTimeAgoSinceNow]]];

    return cell;
}



@end

