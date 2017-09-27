//
//  BPToiletOptionViewCell.h
//  toilet
//
//  Created by kyungtaek on 2015. 10. 25..
//  Copyright © 2015년 bezierpaths. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BPToiletOptionViewCellStatus) {
    BPToiletOptionViewCellStatusOn,
    BPToiletOptionViewCellStatusOff,
    BPToiletOptionViewCellStatusNoData,
};

@interface BPToiletOptionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSString *key;
@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) IBOutlet UILabel *iconNameLabel;

+ (NSString *)cellIdentifier;

- (void)setStatus:(BPToiletOptionViewCellStatus)staus;

@end
