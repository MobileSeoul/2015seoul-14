//
//  BPAutoCompleteLocationListViewController.m
//  toilet
//
//  Created by kyungtaek on 2015. 10. 11..
//  Copyright (c) 2015년 bezierpaths. All rights reserved.
//

#import "BPAutoCompleteLocationListViewController.h"
#import "BPDefineUtility.h"

@interface BPAutoCompleteLocationListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation BPAutoCompleteLocationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.tableView setEstimatedRowHeight:44.f];
    [self.tableView setRowHeight:UITableViewAutomaticDimension];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setAdressList:(NSArray *)adressList {
    _adressList = adressList;

    BP_BLOCK_WEAK wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [wself.tableView reloadData];
    });
    
    if (!adressList || adressList.count == 0) {
        [self.closeButton setHidden:NO];
    } else {
        [self.closeButton setHidden:YES];
    }
}

- (void)setupListFrame:(CGRect)frame {

    [self.tableView setFrame:frame];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.adressList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell.textLabel setText:self.adressList[(NSUInteger) indexPath.row][@"name"]];
    [cell.textLabel setFont:[UIFont systemFontOfSize:13.f]];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell.textLabel setNumberOfLines:0];
    [cell.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *selectedLocation = self.adressList[(NSUInteger) indexPath.row];
    BP_RUN_BLOCK(self.onSelectAddress, selectedLocation[@"name"], selectedLocation[@"placeID"]);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}


- (void)touchUpCloseButton:(id)sender {
    BP_RUN_BLOCK(self.onSelectAddress, nil, nil);
}


@end
