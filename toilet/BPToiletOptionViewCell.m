//
//  BPToiletOptionViewCell.m
//  toilet
//
//  Created by kyungtaek on 2015. 10. 25..
//  Copyright © 2015년 bezierpaths. All rights reserved.
//

#import "BPToiletOptionViewCell.h"
#import "UIColor+BPAddition.h"

@implementation BPToiletOptionViewCell

+ (NSString *)cellIdentifier {
    return NSStringFromClass([self class]);
}

- (void)setKey:(NSString *)key {
    _key = key;
    [self.iconNameLabel setText:NSLocalizedString(_key, nil)];
}


- (void)setStatus:(BPToiletOptionViewCellStatus)staus {
    switch(staus) {

        case BPToiletOptionViewCellStatusOn:{
            [self.iconNameLabel setTextColor:[UIColor bp_greenMintColor]];
            [self.iconImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", self.key]]];
            break;
        }
        case BPToiletOptionViewCellStatusOff:{
            [self.iconImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_gray.png", self.key]]];
            [self.iconNameLabel setTextColor:[UIColor grayColor]];
            break;
        }
        case BPToiletOptionViewCellStatusNoData:{
            [self.iconNameLabel setTextColor:[UIColor grayColor]];
            [self.iconImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_empty.png", self.key]]];
            break;
        }
    }
}

@end
