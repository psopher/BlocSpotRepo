//
//  LocationsTableViewController.m
//  BlocSpot
//
//  Created by Philip Sopher on 8/21/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "BSLocationsTableViewController.h"
#import "BSMapViewController.h"
#import "BSSearchViewController.h"
#import "BSCategoryTableViewController.h"

#define mapImage @"globe"
#define categoryImage @"category"

@interface BSLocationsTableViewController ()

@property (nonatomic, strong) UIBarButtonItem *mapButton;
@property (nonatomic, strong) UIBarButtonItem *categoryButton;

@property (strong, nonatomic) BSMapViewController *mapVC;
@property (strong, nonatomic) BSSearchViewController *searchVC;
@property (strong, nonatomic) BSCategoryTableViewController *categoryVC;

@end

@implementation BSLocationsTableViewController

- (instancetype) init {

    self = [super init];
    
    if (self) {
        
        self.title = NSLocalizedString(@"BlocSpot", @"BlocSpot");
    }
    
    return self;
}

- (void) viewDidLoad {
    
    [self createButtons];
    
}

#pragma Dealing With Buttons for Navigation Bar

- (void) searchPressed:(UIBarButtonItem *)sender {
    
    self.searchVC = [[BSSearchViewController alloc] init];
    
    [self.navigationController pushViewController:self.searchVC animated:YES];
}

- (void) mapPressed:(UIBarButtonItem *)sender {
    
    self.mapVC = [[BSMapViewController alloc] init];
    
    [self.navigationController pushViewController:self.mapVC animated:YES];
}

- (void) categoryPressed:(UIBarButtonItem *)sender {
    
    self.categoryVC = [[BSCategoryTableViewController alloc] init];
    
    [self.navigationController pushViewController:self.categoryVC animated:YES];
}

- (void) createButtons {
    self.mapButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:mapImage]
                                                     style:UIBarButtonItemStylePlain
                                                    target:self
                                                    action:@selector(mapPressed:)];
    
    self.categoryButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:categoryImage]
                                                     style:UIBarButtonItemStylePlain
                                                    target:self
                                                    action:@selector(categoryPressed:)];
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchPressed:)];
    
    self.navigationItem.leftBarButtonItem = self.mapButton;
    
    self.navigationItem.rightBarButtonItems = @[self.categoryButton, searchButton];
}


@end
