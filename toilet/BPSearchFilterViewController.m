//
//  BPSearchFilterViewController.m
//  toilet
//
//  Created by kyungtaek on 2015. 10. 15..
//  Copyright © 2015년 bezierpaths. All rights reserved.
//

#import "BPSearchFilterViewController.h"
#import "BPDefineUtility.h"
#import "BPToiletOptionViewCell.h"

@interface BPSearchFilterViewController ()

@end

@implementation BPSearchFilterViewController
- (instancetype)initWithFilterOptions:(NSArray *)filterOptions completion:(void (^)(NSArray *))completion {
    self = [super init];
    if (self) {
        self.filterOptions = [NSMutableArray arrayWithArray:filterOptions];
        self.completion = completion;
    }

    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    [self setupViews];
}

- (void)setupNavigationBar {
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)setupViews {

    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BPToiletOptionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:[BPToiletOptionViewCell cellIdentifier]];
    FSQCollectionViewAlignedLayout *layout = (FSQCollectionViewAlignedLayout *) [self.collectionView collectionViewLayout];
    [self.collectionView setAllowsMultipleSelection:YES];
    [layout setDefaultCellSize:CGSizeMake(50.f,50.f)];
    [layout setContentInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [layout setDefaultCellAttributes:[FSQCollectionViewAlignedLayoutCellAttributes defaultCellAttributes]];

    [self.resetButton.layer setCornerRadius:2.5f];
    [self.resetButton setClipsToBounds:YES];

    [self.applyButton.layer setCornerRadius:2.5f];
    [self.applyButton setClipsToBounds:YES];

    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)resetFilter {

    BP_RUN_BLOCK(self.completion, @[]);
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)closeButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)saveFilter {

    BP_RUN_BLOCK(self.completion, self.filterOptions);
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

        return [BPToiletInfo defaultOptions].count;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    BPToiletOptionViewCell *cell = (BPToiletOptionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:[BPToiletOptionViewCell cellIdentifier] forIndexPath:indexPath];

    NSString *defaultOptionKey = [BPToiletInfo defaultOptions][(NSUInteger) indexPath.row];
    [cell setKey:defaultOptionKey];

    if ([self.filterOptions containsObject:defaultOptionKey]) {
        [cell setStatus:BPToiletOptionViewCellStatusOn];
    } else {
        [cell setStatus:BPToiletOptionViewCellStatusOff];
    }

    return cell;

}

- (FSQCollectionViewAlignedLayoutSectionAttributes *)collectionView:(UICollectionView *)collectionView
                                                             layout:(FSQCollectionViewAlignedLayout *)collectionViewLayout
                                        attributesForSectionAtIndex:(NSInteger)sectionIndex {
    return [FSQCollectionViewAlignedLayoutSectionAttributes centerCenterAlignment];
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    [collectionView deselectItemAtIndexPath:indexPath animated:NO];

    NSString *key = [BPToiletInfo defaultOptions][(NSUInteger) indexPath.row];
    if (![self.filterOptions containsObject:key]) {
        [self.filterOptions addObject:key];
    } else {
        [self.filterOptions removeObject:key];
    }

    NSString *defaultOptionKey = [BPToiletInfo defaultOptions][(NSUInteger) indexPath.row];
    BPToiletOptionViewCell *cell = (BPToiletOptionViewCell *) [collectionView cellForItemAtIndexPath:indexPath];
    [cell setKey:defaultOptionKey];

    if ([self.filterOptions containsObject:defaultOptionKey]) {
        [cell setStatus:BPToiletOptionViewCellStatusOn];
    } else {
        [cell setStatus:BPToiletOptionViewCellStatusOff];
    }

}

@end
