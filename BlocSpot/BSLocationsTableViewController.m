//
//  LocationsTableViewController.m
//  BlocSpot
//
//  Created by Philip Sopher on 8/21/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "BSLocationsTableViewController.h"
//#import "BSMapViewController.h"
#import "BSSearchTableViewController.h"
#import "BSCategoryTableView.h"
#import "BSLocationsListTableViewCell.h"
#import "BSDataSource.h"
#import "BSBlocSpotData.h"

#define mapImage @"globe"
#define categoryImage @"category"

@interface BSLocationsTableViewController () <UIViewControllerTransitioningDelegate>

//@property (strong, nonatomic) BSMapViewController *mapVC;
@property (strong, nonatomic) BSSearchTableViewController *searchVC;
@property (strong, nonatomic) BSCategoryTableView *categoryVC;

@end

@implementation BSLocationsTableViewController

- (instancetype) init {

    self = [super init];
    
    if (self) {
        
        self.title = NSLocalizedString(@"Locations", @"Locations List");
        
        self.searchVC = [[BSSearchTableViewController alloc] init];
//        self.mapVC = [[BSMapViewController alloc] init];
        self.categoryVC = [[BSCategoryTableView alloc] init];
    }
    
    return self;
}

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    [self createButtons];
    
    [self.tableView registerClass:[BSLocationsListTableViewCell class] forCellReuseIdentifier:@"locationsCell"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadLocationsList:)name:@"locationsListReload"
                                               object:nil];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[BSDataSource sharedInstance].blocSpotDataMutableArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BSLocationsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"locationsCell" forIndexPath:indexPath];

    
    //Sort by distance from current location HERE
    
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES];
//    [[BSDataSource sharedInstance].blocSpotDataMutableArray sortUsingDescriptors:@[sortDescriptor]];
    
    [[BSDataSource sharedInstance].blocSpotDataMutableArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            CLLocationDistance numberA = [(BSBlocSpotData*)obj1 distance];
            CLLocationDistance numberB = [(BSBlocSpotData*)obj2 distance];
        
//            int intValueA = [numberA intValue];
//            int intValueB = [numberB intValue];
        
            if (numberA > numberB) {
                return NSOrderedDescending;
            } else if (numberA < numberB) {
                return NSOrderedAscending;
            }
            return NSOrderedSame;
    }];
    
    cell.locationsItem = [BSDataSource sharedInstance].blocSpotDataMutableArray[indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSLog(@"This method fired: BSLocationsTableViewController cellForRowAtIndexPath");
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat cellHeight = CGRectGetHeight(self.view.frame)/8; //80.875
    
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [tableView
                                  cellForRowAtIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

#pragma Dealing With Buttons for Navigation Bar

- (void) searchPressed:(UIBarButtonItem *)sender {
    
    [self.navigationController pushViewController:self.searchVC animated:YES];
}

//- (void) mapPressed:(UIBarButtonItem *)sender {
//    
//    [self.navigationController pushViewController:self.mapVC animated:YES];
//}

- (void) categoryPressed:(UIBarButtonItem *)sender {
    
//    self.categoryVC.transitioningDelegate = self;
//    self.categoryVC.modalPresentationStyle = UIModalPresentationCustom;
    
//    [self.navigationController pushViewController:self.categoryVC animated:YES];
}

- (void) createButtons {
//    self.mapButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:mapImage]
//                                                     style:UIBarButtonItemStylePlain
//                                                    target:self
//                                                    action:@selector(mapPressed:)];
    
    self.categoryButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:categoryImage]
                                                     style:UIBarButtonItemStylePlain
                                                    target:self
                                                    action:@selector(categoryPressed:)];
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchPressed:)];
    
//    self.navigationItem.leftBarButtonItem = self.mapButton;
    
    self.navigationItem.rightBarButtonItems = @[self.categoryButton, searchButton];
}

#pragma mark - NSNotifications

- (void) reloadLocationsList:(NSNotification *)notification {
    
    [self.tableView reloadData];
    
    NSLog(@"This method fired: reloadLocationsList");
    
}

@end
