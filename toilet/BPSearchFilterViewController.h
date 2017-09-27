//
//  BPSearchFilterViewController.h
//  toilet
//
//  Created by kyungtaek on 2015. 10. 15..
//  Copyright © 2015년 bezierpaths. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BPToiletInfo.h"
#import "FSQCollectionViewAlignedLayout.h"

@interface BPSearchFilterViewController : UIViewController <UICollectionViewDataSource, FSQCollectionViewDelegateAlignedLayout, UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray *filterOptions;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UIButton *resetButton;
@property (nonatomic, weak) IBOutlet UIButton *applyButton;

@property (nonatomic, copy) void (^completion)(NSArray *filterOptions);

- (instancetype)initWithFilterOptions:(NSArray *)filterOptions completion:(void (^)(NSArray *))completion;

- (IBAction)saveFilter;
- (IBAction)resetFilter;
- (IBAction)closeButton;

@end
