//
//  BPToiletListViewController.m
//  toilet
//
//  Created by kyungtaek on 2015. 8. 20..
//  Copyright (c) 2015년 bezierpaths. All rights reserved.
//

#import "BPToiletListViewController.h"
#import "BPLocationManager.h"
#import "BPDefineUtility.h"
#import "BPAPI.h"
#import "BPAutoCompleteLocationListViewController.h"
#import "JTProgressHUD.h"
#import "EBCardCollectionViewLayout.h"
#import "BPToiletCardCell.h"
#import "BPToiletMapAnnotation.h"
#import "BPSearchFilterViewController.h"
#import "LGSemiModalNavViewController.h"
#import "BPToiletCardView.h"
#import "BPToiletDetailViewController.h"
#import "BPSetting.h"
#import "UIColor+BPAddition.h"
#import "UIImage+BPAddition.h"


@interface BPToiletListViewController () <UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate, MKMapViewDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *cardCollectionView;
@property (nonatomic, weak) IBOutlet UIButton *changeSortingOptionButton;
@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, weak) IBOutlet UILabel *emptyCardLabel;
@property (nonatomic, weak) UISearchBar *searchBar;
@property (nonatomic, weak) BPAutoCompleteLocationListViewController *autoCompleteLocationListViewController;

@property (nonatomic, assign) BPPriorityType priorityType;
@property (nonatomic, strong) NSArray *filterOptions;

@property(nonatomic, weak) IBOutlet UIButton *sortingOptionButton;

@property (nonatomic, assign) CLLocationCoordinate2D fetchingCoordinate;
@property (nonatomic, strong) NSArray *toiletList;
@property (nonatomic, strong) NSMutableArray *mapAnnotations;

@property(nonatomic) BOOL isFetching;

@end

@implementation BPToiletListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupProperties];
    [self setupSubViewControlelr];
    [self setupNavigationBar];
    [self setupViews];
    [self fetchMyLocation];

}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.searchBar setValue:[UIColor whiteColor] forKeyPath:@"searchField.textColor"];
}

- (void)setupSubViewControlelr {

    BP_BLOCK_WEAK wself = self;
    BPAutoCompleteLocationListViewController *autoCompleteLocationListViewController = [[BPAutoCompleteLocationListViewController alloc] init];
    [autoCompleteLocationListViewController setOnSelectAddress:^(NSString *name, NSString *placeID) {

        [wself dismissAutocompletingList];

        if (!name || !placeID) {
            return;
        }


        [[BPLocationManager instance] fetchCoordinateFromGooglePlaceID:placeID completion:^(CLLocationCoordinate2D coordinate2D, NSError *error) {
            if (!error) {
                [[BPLocationManager instance] stopRequestCurrentLocation];
                [wself.searchBar setText:name];
                [wself setFetchingCoordinate:coordinate2D];
                [wself updateLocationMapView];
                [wself fetchToiletLists];
            }
        }];
    }];

    [self addChildViewController:autoCompleteLocationListViewController];
    [self.view addSubview:autoCompleteLocationListViewController.view];
    [self setAutoCompleteLocationListViewController:autoCompleteLocationListViewController];
    [self.autoCompleteLocationListViewController didMoveToParentViewController:self];
    [self.autoCompleteLocationListViewController.view setFrame:self.view.bounds];
    [self.autoCompleteLocationListViewController.view setHidden:YES];

}

- (void)setupProperties {
    self.priorityType = BPPriorityTypeRating;
    self.filterOptions = @[];
    self.toiletList = [NSArray new];
    self.mapAnnotations = [NSMutableArray new];
    self.fetchingCoordinate = CLLocationCoordinate2DMake(37.5666103, 126.9783882);
}


- (void)setupNavigationBar {

    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
    self.searchBar = searchBar;
    [self.searchBar setPlaceholder:NSLocalizedString(@"SEARCH", nil)];

    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    searchBar.barTintColor = [UIColor whiteColor];
    searchBar.tintColor = [UIColor whiteColor];
    [searchBar setImage:[UIImage imageNamed:@"search_icon.png"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [searchBar setImage:[UIImage imageNamed:@"search_cancel.png"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];

    [[UILabel appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor whiteColor]];

    [self setEdgesForExtendedLayout:UIRectEdgeNone];

    UIButton *naviLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [naviLeftButton setImage:[UIImage imageNamed:@"location.png"] forState:UIControlStateNormal];
    [naviLeftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [naviLeftButton addTarget:self action:@selector(touchUpDetectMyLocation:) forControlEvents:UIControlEventTouchUpInside];
    [naviLeftButton sizeToFit];

    UIBarButtonItem *minusMarginItem = [[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                 target:nil
                                 action:nil];
    minusMarginItem.width = -10;

    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:naviLeftButton];
    self.navigationItem.leftBarButtonItems = @[minusMarginItem, leftBarButtonItem];

    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    [self.navigationController.navigationBar setBackgroundImage:[UIColor bp_imageFromColor:[UIColor bp_colorFromHexString:@"#12b3a5"]] forBarMetrics:UIBarMetricsDefault];
}

- (void)setupViews {
    self.mapView.delegate = self;
    self.mapView.showsBuildings = YES;

    UIOffset anOffset = UIOffsetMake(16, 8);
    [(EBCardCollectionViewLayout *)self.cardCollectionView.collectionViewLayout setOffset:anOffset];
    [(EBCardCollectionViewLayout *)self.cardCollectionView.collectionViewLayout setLayoutType:EBCardCollectionLayoutHorizontal];

    [self.cardCollectionView registerNib:[UINib nibWithNibName:[BPToiletCardCell cellIdentifier] bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:[BPToiletCardCell cellIdentifier]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)fetchToiletLists {

    if(self.isFetching) {
        return;
    }

    [self.emptyCardLabel setHidden:YES];

    self.isFetching = YES;
    [self.mapView removeAnnotations:self.mapAnnotations];

    [JTProgressHUD show];
    BP_BLOCK_WEAK wself = self;
    [BPAPI fetchToiletInfoWithCurrentLocation:self.fetchingCoordinate priority:self.priorityType filterOptions:self.filterOptions completion:^(NSArray *toiletList, NSError *error) {

        [wself.emptyCardLabel setHidden:toiletList.count > 0];
        [JTProgressHUD hide];
        if (error) {
            return;
        }

        wself.toiletList = toiletList;
        wself.isFetching = NO;

        dispatch_async(dispatch_get_main_queue(), ^{
            [wself.cardCollectionView reloadData];
            [wself.cardCollectionView setContentOffset:CGPointZero];
            [wself.toiletList enumerateObjectsUsingBlock:^(BPToiletInfo *toiletInfo, NSUInteger idx, BOOL *stop) {

                BPToiletMapAnnotation *newAnnotation = [[BPToiletMapAnnotation alloc] initWithCoordinate:toiletInfo.coordinate title:toiletInfo.name sn:toiletInfo.sn];
                [wself.mapView addAnnotation:newAnnotation];
                [wself.mapAnnotations addObject:newAnnotation];

                if (idx == 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [wself zoomToToiletAnnotation:toiletInfo];
                    });

                }
            }];
        });
    }];
}


- (void)fetchMyLocation {
    BP_BLOCK_WEAK wself = self;

    [self dismissAutocompletingList];

    [JTProgressHUD show];
    [[BPLocationManager instance] requestCurrentLocationWithCompletion:^(CLLocation *currentLocation, NSString *name, NSError *error) {
        [JTProgressHUD hide];

        if (!error) {
            [[BPLocationManager instance] stopRequestCurrentLocation];
            [wself.searchBar setText:name];
            [wself setFetchingCoordinate:currentLocation.coordinate];
            [wself fetchToiletLists];
        }
    }];
}

- (void)displayMap:(BPToiletInfo *)toiletInfo {

    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:toiletInfo.coordinate addressDictionary:nil];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    [mapItem setName:toiletInfo.name.length ? toiletInfo.name : toiletInfo.address];

    NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking,
            MKLaunchOptionsMapTypeKey: @(MKMapTypeStandard)};

    MKPlacemark *startPlacemark = [[MKPlacemark alloc] initWithCoordinate:self.fetchingCoordinate addressDictionary:nil];
    MKMapItem *startLocationMapItem = [[MKMapItem alloc] initWithPlacemark:startPlacemark];
    [startLocationMapItem setName:NSLocalizedString(@"출발", nil)];

    // Pass the current location and destination map items to the Maps app
    // Set the direction mode in the launchOptions dictionary
    [MKMapItem openMapsWithItems:@[startLocationMapItem, mapItem]
                   launchOptions:launchOptions];
}



- (void) updateLocationMapView {
    MKCoordinateSpan span = MKCoordinateSpanMake(0.002, 0.002);
    MKCoordinateRegion region = {self.fetchingCoordinate, span};
    [self.mapView setRegion:region];
    [self.mapView setCenterCoordinate:self.fetchingCoordinate animated:YES];
}


- (void)zoomToToiletAnnotation:(BPToiletInfo *)toiletInfo {
    MKCoordinateSpan span = MKCoordinateSpanMake(0.002, 0.002);
    MKCoordinateRegion region = {toiletInfo.coordinate, span};
    [self.mapView setRegion:region];
    [self.mapView setCenterCoordinate:toiletInfo.coordinate animated:YES];

    BP_BLOCK_WEAK wself = self;
    [self.mapAnnotations enumerateObjectsUsingBlock:^(BPToiletMapAnnotation *annotation, NSUInteger idx, BOOL *stop) {
        if ([annotation.sn isEqualToNumber:toiletInfo.sn]) {
            MKAnnotationView *av = [wself.mapView viewForAnnotation:annotation];
            av.image = [UIImage imageNamed:@"pin_toilet.png"];
        } else {
            MKAnnotationView *av = [wself.mapView viewForAnnotation:annotation];
            av.image = [[UIImage imageNamed:@"pin_toilet.png"] bp_changeColor:[UIColor bp_colorFromHexString:@"#bbbbbb"]];

        }
    }];

}


- (void) showAutocompletingListsIfNeeds:(NSArray *)autoCompletingAddresses withError:(NSError *)error {

    self.autoCompleteLocationListViewController.adressList = autoCompletingAddresses;
    [self.autoCompleteLocationListViewController.view setHidden:NO];
    [self.autoCompleteLocationListViewController setupListFrame:self.view.bounds];

    [self.autoCompleteLocationListViewController.view setAlpha:0.0f];
    [UIView animateWithDuration:0.2f animations:^{
        [self.autoCompleteLocationListViewController.view setAlpha:1.f];
    }];
}

- (void) dismissAutocompletingList {
    [self.autoCompleteLocationListViewController.view setHidden:YES];
    [self.searchBar resignFirstResponder];
}


- (IBAction) touchUpChangeFilterOption:(id)sender {

    BP_BLOCK_WEAK wself = self;
    BPSearchFilterViewController *viewController = [[BPSearchFilterViewController alloc] initWithFilterOptions:self.filterOptions completion:^(NSArray *options) {
        wself.filterOptions = options;
        [wself fetchToiletLists];
    }];

    LGSemiModalNavViewController *modalNavViewController = [[LGSemiModalNavViewController alloc] initWithRootViewController:viewController];
    modalNavViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 230);
    modalNavViewController.backgroundShadeColor = [UIColor blackColor];
    modalNavViewController.animationSpeed = 0.35f;
    modalNavViewController.tapDismissEnabled = YES;
    modalNavViewController.backgroundShadeAlpha = 0.4;
    modalNavViewController.scaleTransform = CGAffineTransformMakeScale(.94, .94);

    [self presentViewController:modalNavViewController animated:YES completion:nil];
}


- (IBAction)touchUpDetectMyLocation:(id)sender {
    [self fetchMyLocation];
}

- (IBAction)touchUpSortingOptionButton:(id)sender {

    [self.sortingOptionButton setSelected:!self.sortingOptionButton.selected];

    if (self.sortingOptionButton.selected) {
        //Distance
        self.priorityType = BPPriorityTypeDistance;
    } else {
        //Rating
        self.priorityType = BPPriorityTypeRating;
    }

    [self fetchToiletLists];
}



- (void) handleGetRouteToToilet:(BPToiletInfo *)toiletInfo {

    CLLocationCoordinate2D startCoordinate = self.fetchingCoordinate;
    CLLocationCoordinate2D endCoordinate = toiletInfo.coordinate;

    NSString* versionNum = [[UIDevice currentDevice] systemVersion];
    NSString *nativeMapScheme = @"maps.apple.com";
    if ([versionNum compare:@"6.0" options:NSNumericSearch] == NSOrderedAscending) {
        nativeMapScheme = @"maps.google.com";
    }
    NSString* url = [NSString stringWithFormat: @"http://%@/maps?saddr=%f,%f&daddr=%f,%f", nativeMapScheme, startCoordinate.latitude, startCoordinate.longitude, endCoordinate.latitude, endCoordinate.longitude];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}


- (void) registerLocalNotification:(BPToiletInfo *)toiletInfo {

    [[UIApplication sharedApplication] cancelAllLocalNotifications];

    //NSUInteger delayTime = 60 * 60 * 1; //1시간
    NSUInteger delayTime = 5;

    NSDate *itemDate = [NSDate dateWithTimeIntervalSinceNow:delayTime];
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil) {
        return;
    }
    localNotif.fireDate = itemDate;
    localNotif.timeZone = [NSTimeZone systemTimeZone];

    localNotif.alertBody = [NSString stringWithFormat:NSLocalizedString(@"%@ 화장실의 후기를 남겨주세요!", nil), toiletInfo.name.length > 0 ? toiletInfo.name : NSLocalizedString(@"방금 다녀가신", )];
    localNotif.alertAction = NSLocalizedString(@"평가하기", nil);

    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = 1;
    localNotif.userInfo = @{@"toiletRawInfo":toiletInfo.responseRawDic};
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];



}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.toiletList.count;
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [self showAutocompletingListsIfNeeds:@[] withError:nil];
    return YES;
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {

    BP_BLOCK_WEAK wself = self;
    [[BPLocationManager instance] fetchAutocompleteLocation:searchBar.text completion:^(NSArray *locationList, NSError *error) {
        [wself showAutocompletingListsIfNeeds:locationList withError:error];
    }];
}

- (UIView *)currentCardCell {
    NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:CGPointMake(CGRectGetMidX(self.cardCollectionView.bounds), CGRectGetMidY(self.cardCollectionView.bounds))];
    BPToiletCardCell *currentCell = (BPToiletCardCell *) [self.cardCollectionView cellForItemAtIndexPath:indexPath];
    return currentCell;
}


#pragma mark - CollectionViewDatasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.toiletList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    BP_BLOCK_WEAK wself = self;
    BPToiletCardCell *cell = (BPToiletCardCell *) [collectionView dequeueReusableCellWithReuseIdentifier:[BPToiletCardCell cellIdentifier] forIndexPath:indexPath];
    [cell.cardView setCurrentCoordinate:self.fetchingCoordinate];
    [cell.cardView setToiletInfo:self.toiletList[(NSUInteger) indexPath.row]];
    [cell.cardView cardIndex:(NSUInteger) (indexPath.row + 1) total:self.toiletList.count];
    [cell.cardView setHandleGetRoute:^(BPToiletInfo *info) {
        [wself displayMap:info];
        [[BPSetting instance] setCurrentInterestingToiletInfo:info];
        [wself registerLocalNotification:info];
    }];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];

    BPToiletDetailViewController *detailViewController = [BPToiletDetailViewController viewControllerWithCardCell:[self currentCardCell]];
    [self presentViewController:detailViewController animated:YES completion:nil];
}


#pragma kar - ScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:CGPointMake(CGRectGetMidX(self.cardCollectionView.bounds), CGRectGetMidY(self.cardCollectionView.bounds))];
    if (indexPath) {
        BPToiletInfo *toiletInfo = self.toiletList[(NSUInteger) indexPath.row];
        [self zoomToToiletAnnotation:toiletInfo];
    }
}


#pragma mark - MapViewDelegate

- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {

    if ([annotation isKindOfClass:[BPToiletMapAnnotation class]]) {
        BPToiletMapAnnotation *toiletAnnotation = annotation;

        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"BPToiletMapAnnotation"];
        if (!annotationView) {
            annotationView = toiletAnnotation.annotationView;
        } else {
            annotationView.annotation = toiletAnnotation;
        }
        return annotationView;
    } else {
        return nil;
    }

}


@end
