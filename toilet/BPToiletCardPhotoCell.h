//
//  BPToiletCardPhotoCell.h
//  toilet
//
//  Created by kyungtaek on 2015. 10. 19..
//  Copyright © 2015년 bezierpaths. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BPToiletCardPhotoCell : UICollectionViewCell

@property(nonatomic, weak) IBOutlet UIImageView *imageView;
@property(nonatomic, assign) BOOL isLoaded;

+ (NSString *)cellIdentifier;

@end
