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
        
        self.title = NSLocalizedString(@"List", @"Locations List");
        
        self.searchVC = [[BSSearchTableViewController alloc] init];
//        self.mapVC = [[BSMapViewController alloc] init];
        self.categoryVC = [[BSCategoryTableView alloc] init];
    }
    
    return self;
}

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    [self createButtons];
    
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    //array is your db, here we just need how many they are
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    
//    return [BTDataSource sharedInstance].conversations.count;
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

//- (UITableViewCellAccessoryType)tableView:(UITableView *)tv accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
//    return UITableViewCellAccessoryDisclosureIndicator;
//}

//- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
//    CGFloat padding = 20;
//    CGFloat tableViewWidth = viewWidth - padding;
//    
//    BTConversation *item = [BTDataSource sharedInstance].conversations[indexPath.row];
//    
//    return [BTConversationsTableViewCell heightForMediaItem:item width:tableViewWidth];
//}

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

#pragma mark - UIViewControllerTransitioningDelegate

//- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
//                                                                  presentingController:(UIViewController *)presenting
//                                                                      sourceController:(UIViewController *)source {
//    
//    BSCategoryTransitionAnimator *animator = [BSCategoryTransitionAnimator new];
//    animator.presenting = YES;
////    animator.cellImageView = self.lastTappedImageView;
//    return animator;
//}
//
//- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
//    BSCategoryTransitionAnimator *animator = [BSCategoryTransitionAnimator new];
////    animator.cellImageView = self.lastTappedImageView;
//    return animator;
//}

@end
