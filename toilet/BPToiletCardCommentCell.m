//
//  BPToiletCardCommentCell.m
//  toilet
//
//  Created by kyungtaek on 2015. 10. 19..
//  Copyright © 2015년 bezierpaths. All rights reserved.
//

#import "BPToiletCardCommentCell.h"

@implementation BPToiletCardCommentCell

+ (NSString *)cellIdentifier {
    return NSStringFromClass([self class]);
}

- (void)awakeFromNib {
    [super awakeFromNib];

    UIView *splitLineView = [[UIView alloc] initWithFrame:CGRectZero];
    [splitLineView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"commetn_dotline.png"]]];
    [splitLineView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:splitLineView];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[splitLineView]-(10)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(splitLineView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[splitLineView(0.5)]-(0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(splitLineView)]];
}


@end
