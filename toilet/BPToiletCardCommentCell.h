//
//  BPToiletCardCommentCell.h
//  toilet
//
//  Created by kyungtaek on 2015. 10. 19..
//  Copyright © 2015년 bezierpaths. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BPToiletCardCommentCell : UITableViewCell

@property(nonatomic, weak) IBOutlet UILabel *commentLabel;
@property(nonatomic, weak) IBOutlet UILabel *dateLabel;

+ (NSString *)cellIdentifier;
@end
