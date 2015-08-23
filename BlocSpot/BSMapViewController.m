//
//  ViewController.m
//  BlocSpot
//
//  Created by Philip Sopher on 8/21/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "BSMapViewController.h"
#import "BSSearchTableViewController.h"
#import "BSCategoryTableViewController.h"
#import "BSCategoryTransitionAnimator.h"

#define categoryImage @"category"

@interface BSMapViewController () <UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) UIBarButtonItem *categoryButton;

@property (strong, nonatomic) BSSearchTableViewController *searchVC;
@property (strong, nonatomic) BSCategoryTableViewController *categoryVC;

@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation BSMapViewController

- (instancetype) init {
    
    self = [super init];
    
    if (self) {
        
        self.mapView = [[MKMapView alloc] init];
        [self.view addSubview:self.mapView];
        
        self.title = NSLocalizedString(@"Map", @"Map View");
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    [self.mapView setShowsUserLocation:YES];
    [self.locationManager requestAlwaysAuthorization];
    
    [self createButtons];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGFloat viewWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat yOrigin = self.navigationController.navigationBar.bounds.size.height;
    CGFloat viewHeight = [UIScreen mainScreen].bounds.size.height - yOrigin;
    
    self.mapView.frame = CGRectMake(0, yOrigin, viewWidth, viewHeight);
    
}

#pragma Setting Map View Zoom and User Location

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion mapRegion;
    mapRegion.center = mapView.userLocation.coordinate;
    mapRegion.span.latitudeDelta = 0.2;
    mapRegion.span.longitudeDelta = 0.2;
    
    [mapView setRegion:mapRegion animated: YES];
}

#pragma Dealing With Buttons for Navigation Bar

- (void) searchPressed:(UIBarButtonItem *)sender {
    
    self.searchVC = [[BSSearchTableViewController alloc] init];
    
    [self.navigationController pushViewController:self.searchVC animated:YES];
}

- (void) categoryPressed:(UIBarButtonItem *)sender {
    
    self.categoryVC = [[BSCategoryTableViewController alloc] init];
    
    [self.navigationController pushViewController:self.categoryVC animated:YES];
}

- (void) createButtons {
    
    self.categoryButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:categoryImage]
                                                          style:UIBarButtonItemStylePlain
                                                         target:self
                                                         action:@selector(categoryPressed:)];
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchPressed:)];
    
    self.navigationItem.rightBarButtonItems = @[self.categoryButton, searchButton];
}


@end
