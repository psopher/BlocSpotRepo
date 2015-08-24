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

@property (strong, nonatomic) BSSearchTableViewController *searchVC;
@property (strong, nonatomic) BSCategoryTableViewController *categoryVC;

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
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;

    if(IS_OS_8_OR_LATER) {
        // Use one or the other, not both. Depending on what you put in info.plist
//        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
    
    [self.mapView setShowsUserLocation:YES];
    [self.mapView setMapType:MKMapTypeStandard];
    [self.mapView setZoomEnabled:YES];
    [self.mapView setScrollEnabled:YES];
    
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

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    [CLLocationManager authorizationStatus];
    NSLog(@"My device is located at %@", [self deviceLocation]);
    
}

#pragma Setting Map View Zoom and User Location

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    
    //When running on iphone
    MKCoordinateRegion mapRegion;
    mapRegion.center = mapView.userLocation.coordinate;
    mapRegion.span.latitudeDelta = 0.005;
    mapRegion.span.longitudeDelta = 0.005;
    
    [mapView setRegion:mapRegion animated: YES];
}

//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
//{
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
//    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
//}

- (NSString *)deviceLocation {
    return [NSString stringWithFormat:@"latitude: %f longitude: %f", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude];
}
- (NSString *)deviceLat {
    return [NSString stringWithFormat:@"%f", self.locationManager.location.coordinate.latitude];
}
- (NSString *)deviceLon {
    return [NSString stringWithFormat:@"%f", self.locationManager.location.coordinate.longitude];
}
- (NSString *)deviceAlt {
    return [NSString stringWithFormat:@"%f", self.locationManager.location.altitude];
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
