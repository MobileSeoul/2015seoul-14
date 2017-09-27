//
//  BPIntroViewController.m
//  toilet
//
//  Created by kyungtaek on 2015. 8. 22..
//  Copyright (c) 2015년 bezierpaths. All rights reserved.
//

#import "BPIntroViewController.h"
#import "BPDefineUtility.h"
#import "BPSetting.h"

@interface BPIntroViewController ()

@end

@implementation BPIntroViewController
- (instancetype)initWithCompletion:(void (^)())completion {
    self = [super init];
    if (self) {
        self.completion = completion;
    }

    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.startButton.layer setCornerRadius:24.f];
    [self.startButton setClipsToBounds:YES];
    [self.startButton.layer setBorderColor:[UIColor colorWithWhite:1.0f alpha:0.5f].CGColor];
    [self.startButton.layer setBorderWidth:1.f];

}


- (IBAction) touchUpNextButton:(id)sender {

    [[BPSetting instance] setAlreadyShownIntro:YES];
    BP_RUN_BLOCK(self.completion);

}

@end
