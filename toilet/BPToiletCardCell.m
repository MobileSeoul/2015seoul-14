//
//  BPToiletCardCell.m
//  toilet
//
//  Created by kyungtaek on 2015. 10. 14..
//  Copyright © 2015년 bezierpaths. All rights reserved.
//

#import "BPToiletCardCell.h"
#import "HCSStarRatingView.h"
#import "BPToiletInfo.h"
#import "BPDefineUtility.h"
#import "BPToiletCardView.h"
#import "UIColor+BPAddition.h"

@implementation BPToiletCardCell


- (void)awakeFromNib {
    [super awakeFromNib];

    BPToiletCardView *cardView = [[NSBundle mainBundle] loadNibNamed:@"BPToiletCardView" owner:nil options:nil][0];
    [cardView setFrame:self.bounds];
    [self.cardBaseView addSubview:cardView];
    [self setCardView:cardView];


    [self.layer setCornerRadius:5.f];
    [self.layer setBorderColor:[UIColor bp_colorFromHexString:@"#d5d1d0"].CGColor];
    [self.layer setBorderWidth:1.f];
}


+ (NSString *)cellIdentifier {
    return NSStringFromClass([BPToiletCardCell class]);
}

- (void)setToiletInfo:(BPToiletInfo *)toiletInfo {
    [self.cardView setToiletInfo:toiletInfo];
}


- (BPToiletInfo *)toiletInfo {
    return [self.cardView toiletInfo];
}

@end
