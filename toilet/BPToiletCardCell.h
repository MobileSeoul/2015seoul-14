//
//  BPToiletCardCell.h
//  toilet
//
//  Created by kyungtaek on 2015. 10. 14..
//  Copyright © 2015년 bezierpaths. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class HCSStarRatingView;
@class BPToiletInfo;
@class BPToiletCardView;

@interface BPToiletCardCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIView *cardBaseView;
@property (nonatomic, weak) BPToiletCardView *cardView;

+ (NSString *)cellIdentifier;

@end
