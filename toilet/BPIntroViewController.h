//
//  BPIntroViewController.h
//  toilet
//
//  Created by kyungtaek on 2015. 8. 22..
//  Copyright (c) 2015년 bezierpaths. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BPIntroViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *descLabel;
@property (nonatomic, weak) IBOutlet UIButton *startButton;
@property (nonatomic, copy) void (^completion)(void);

- (instancetype)initWithCompletion:(void (^)())completion;


@end
