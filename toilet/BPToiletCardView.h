//
//  BPToiletCardView.h
//  toilet
//
//  Created by kyungtaek on 2015. 10. 19..
//  Copyright © 2015년 bezierpaths. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "FSQCollectionViewAlignedLayout.h"
#import "NYTPhotosViewController.h"

@class HCSStarRatingView;
@class BPToiletInfo;

@interface BPToiletCardView : UIView <UICollectionViewDataSource, FSQCollectionViewDelegateAlignedLayout, UICollectionViewDelegate, NYTPhotosViewControllerDelegate>

@property(nonatomic, weak) IBOutlet UILabel *countingLabel;
@property(nonatomic, weak) IBOutlet UILabel *ratingCountLabel;
@property(nonatomic, weak) IBOutlet UIView *ratingBaseView;
@property(nonatomic, weak) IBOutlet UILabel *nameLabel;
@property(nonatomic, weak) IBOutlet UILabel *distanceLabel;
@property(nonatomic, weak) IBOutlet UIButton *closeButton;
@property(nonatomic, weak) IBOutlet UICollectionView *optionCollectionView;
@property(nonatomic, weak) HCSStarRatingView *ratingView;
@property(nonatomic, weak) IBOutlet UIButton *getRouteButton;
@property(nonatomic, weak) IBOutlet UILabel *emptyCommentLabel;
@property(nonatomic, weak) IBOutlet UIView *zigzagView;

@property(nonatomic, weak) IBOutlet UICollectionView *photoCollectionView;
@property(nonatomic, weak) IBOutlet UITableView *commentListView;
@property(nonatomic, weak) IBOutlet UIView *detailCardBaseView;
@property(nonatomic, weak) IBOutlet UILabel *simpleOtherContentLabel;

@property(nonatomic, weak) IBOutlet NSLayoutConstraint *optionCollectionViewHeight;

@property(nonatomic, strong) BPToiletInfo *toiletInfo;
@property(nonatomic, assign) CLLocationCoordinate2D currentCoordinate;
@property(nonatomic, copy) void (^handleGetRoute)(BPToiletInfo *);

@property (nonatomic, assign) BOOL isExpendable;
@property (nonatomic, strong) NSTimer *autoRolingTimer;

- (IBAction)onTouchGetRouteButton:(id)sender;
- (IBAction)onTouchCloseDetailView:(id)sender;
- (void)cardIndex:(NSUInteger)index total:(NSUInteger)total;

@end
