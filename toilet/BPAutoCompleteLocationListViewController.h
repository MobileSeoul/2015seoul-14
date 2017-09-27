//
//  BPAutoCompleteLocationListViewController.h
//  toilet
//
//  Created by kyungtaek on 2015. 10. 11..
//  Copyright (c) 2015년 bezierpaths. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface BPAutoCompleteLocationListViewController : UIViewController

@property(nonatomic, weak) IBOutlet UIButton *closeButton;
@property(nonatomic, strong) NSArray *adressList;
@property(nonatomic, copy) void (^onSelectAddress)(NSString *name, NSString *placeID);

- (void)setupListFrame:(CGRect)frame;

- (IBAction)touchUpCloseButton:(id)sender;

@end
