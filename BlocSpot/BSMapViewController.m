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
@property (nonatomic) CGFloat yOriginCategoryView;
@property (nonatomic) CGFloat yOriginBackgroundView;

@end

@implementation BSMapViewController

- (instancetype) init {
    
    self = [super init];
    
    if (self) {
        
        self.mapView = [[MKMapView alloc] init];
        [self.view addSubview:self.mapView];
        
        self.categoryView = [[UIView alloc] init];
        
        self.categoryVC = [[BSCategoryTableViewController alloc] init];
        self.searchVC = [[BSSearchTableViewController alloc] init];
        
        self.title = NSLocalizedString(@"Map", @"Map View");
    }
    
    
    [self.mapView addSubview:self.categoryView];
    
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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissCategoryView)];
    [self.view addGestureRecognizer:tap];
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
    
    [self.navigationController pushViewController:self.searchVC animated:YES];
}

- (void) categoryPressed:(UIBarButtonItem *)sender {
    
    if (self.yOriginCategoryView <= self.yOriginBackgroundView) {
        [self createCategoryView];
        self.categoryVC.transitioningDelegate = self;
        self.categoryVC.modalPresentationStyle = UIModalPresentationCustom;
    } else {
        [self dismissCategoryView];
    };
    
//    [self.navigationController pushViewController:self.categoryVC animated:YES];
}

- (void) createButtons {
    
    self.categoryButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:categoryImage]
                                                          style:UIBarButtonItemStylePlain
                                                         target:self
                                                         action:@selector(categoryPressed:)];
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchPressed:)];
    
    self.navigationItem.rightBarButtonItems = @[self.categoryButton, searchButton];
}

- (void) createCategoryView {
    // the first value puts the view in the center of the map view
    // i made it 200 x 200
    self.categoryView.frame = CGRectMake(CGRectGetMidX(self.mapView.frame) - CGRectGetWidth(self.categoryView.frame) / 2, CGRectGetMinY(self.mapView.frame) - 1000, 200, 200);
    
    self.categoryView.backgroundColor = [UIColor greenColor];
    
    NSLog(@"The category view frame is xOrigin %f, yOrigin %f, width %f, height %f", CGRectGetMinX(self.categoryView.frame), CGRectGetMinY(self.categoryView.frame), self.categoryView.frame.size.width, self.categoryView.frame.size.height);
    
    // 1.5 second long duration of animation,
//    [UIView animateWithDuration:1.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options: 0 animations:^{
    [UIView animateWithDuration:1.5 delay:0 options: 0 animations:^{
        // this new value will drop it down with the spring damping (you can use the regular animateWithDuration method to do without that effect) to 200 below the top edge
        self.categoryView.frame = CGRectMake(CGRectGetMidX(self.mapView.frame) - CGRectGetWidth(self.categoryView.frame) / 2, CGRectGetMinY(self.mapView.frame) + 150, 200, 200);
    } completion: nil];
    
    // alternatively, you can nest some more animations in the completion or whatever you want so that more things happen as soon it completes.
    
    self.yOriginCategoryView = CGRectGetMinY(self.categoryView.frame);
    self.yOriginBackgroundView = CGRectGetMinY(self.view.frame);
    
    NSLog(@"This method ran: createCategoryView");
    NSLog(@"The category view frame is xOrigin %f, yOrigin %f, width %f, height %f", CGRectGetMinX(self.categoryView.frame), CGRectGetMinY(self.categoryView.frame), self.categoryView.frame.size.width, self.categoryView.frame.size.height);
}

-(void)dismissCategoryView {
    
    if (self.yOriginCategoryView > self.yOriginBackgroundView) {
        [UIView animateWithDuration:1.5 delay:0 options: 0 animations:^{
            self.categoryView.frame = CGRectMake(CGRectGetMidX(self.mapView.frame) - CGRectGetWidth(self.categoryView.frame) / 2, CGRectGetMinY(self.mapView.frame) - 1000, 200, 200);
        } completion: nil];
    }
    self.yOriginCategoryView = CGRectGetMinY(self.categoryView.frame);
    self.yOriginBackgroundView = CGRectGetMinY(self.view.frame);
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    
    BSCategoryTransitionAnimator *animator = [[BSCategoryTransitionAnimator alloc] init];
    animator.presenting = YES;
    animator.customCategoryView = self.categoryVC;
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    BSCategoryTransitionAnimator *animator = [[BSCategoryTransitionAnimator alloc] init];
    animator.customCategoryView = self.categoryVC;
    return animator;
}

@end
