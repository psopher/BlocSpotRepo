//
//  ViewController.m
//  BlocSpot
//
//  Created by Philip Sopher on 8/21/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "BSMapViewController.h"
#import "BSSearchTableViewController.h"
#import "BSCategoryTableView.h"
#import "BSLocationsTableViewController.h"
#import "BSDataSource.h"
#import "MKAnnotationViewSubclass.h"
#import "MKAnnotationCalloutView.h"

#define categoryImage @"category"
#define listImage @"list"
#define currentLocationImage @"globe"
#define annotationImage @"heart"

@interface BSMapViewController () <UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) BSLocationsTableViewController *locationsVC;
@property (strong, nonatomic) BSSearchTableViewController *searchVC;
@property (strong, nonatomic) BSCategoryTableView *categoryVC;
@property (nonatomic) CGFloat yOriginCategoryView;
@property (nonatomic) CGFloat yOriginBackgroundView;
@property (strong, nonatomic) MKPolygon *transparentGreyPolygon;
@property (strong, nonatomic) UIPopoverPresentationController *annotationPopover;
@property (strong, nonatomic) MKAnnotationViewSubclass *MKAnnotationViewSubclass;
@property (strong, nonatomic) MKAnnotationCalloutView* annotationCalloutView;

@end

@implementation BSMapViewController

- (instancetype) init {
    
    self = [super init];
    
    if (self) {
        
        self.mapView = [[MKMapView alloc] init];
        [self.view addSubview:self.mapView];
        
        self.categoryTableView = [[BSCategoryTableView alloc] init];
        
        self.locationsVC = [[BSLocationsTableViewController alloc] init];
        self.categoryVC = [[BSCategoryTableView alloc] init];
        self.searchVC = [[BSSearchTableViewController alloc] init];
        
        self.title = NSLocalizedString(@"Map", @"Map View");
        
        self.transparentGreyPolygon = [[MKPolygon alloc] init];
        
        self.MKAnnotationViewSubclass = [[MKAnnotationViewSubclass alloc] init];
        self.annotationCalloutView = [[MKAnnotationCalloutView alloc] init];
    }
    
    
    [self.mapView addSubview:self.categoryTableView];
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadMapView:)name:@"searchCreatedMapAnnotation"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadCategoryView:)name:@"numberOfRowsChanged"
                                               object:nil];
    
    NSLog(@"This method ran: BSMapViewController viewDidLoad");
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
    
    CGFloat padding = 40;
    
    self.refreshCurrentLocationButton.frame = CGRectMake(self.mapView.frame.size.width - padding, self.mapView.frame.size.height - padding, 22, 22);
    
    NSLog(@"This method ran: BSMapViewController viewWillLayoutSubviews");
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    [CLLocationManager authorizationStatus];
   
    NSLog(@"My device is located at %@", [self deviceLocation]);
    NSLog(@"This method ran: BSMapViewController viewDidAppear");
    
}

#pragma Setting Map View Zoom and User Location

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    
    //When running on iphone
    MKCoordinateRegion mapRegion;
    mapRegion.center = mapView.userLocation.coordinate;
    mapRegion.span.latitudeDelta = 0.007;
    mapRegion.span.longitudeDelta = 0.007;
    
    [mapView setRegion:mapRegion animated: YES];
    
    [BSDataSource sharedInstance].mapViewCurrent = self.mapView;
    [BSDataSource sharedInstance].mapViewCurrentRegion = &(mapRegion);
    
    NSLog(@"This method ran: didUpdateUserLocation");
}

- (NSString *)deviceLocation {
    
    NSLog(@"This method ran: deviceLocation");
    
    return [NSString stringWithFormat:@"latitude: %f longitude: %f", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude];
}
- (NSString *)deviceLat {
    
    NSLog(@"This method ran: deviceLat");
    
    return [NSString stringWithFormat:@"%f", self.locationManager.location.coordinate.latitude];
}
- (NSString *)deviceLon {
    
    NSLog(@"This method ran: deviceLon");
    
    return [NSString stringWithFormat:@"%f", self.locationManager.location.coordinate.longitude];
}
- (NSString *)deviceAlt {
    
    NSLog(@"This method ran: deviceAlt");
    
    return [NSString stringWithFormat:@"%f", self.locationManager.location.altitude];
}

#pragma Calling new notifications into the map view

- (void) reloadMapView:(NSNotification *)notification {
    
    self.mapView = [BSDataSource sharedInstance].mapViewCurrent;
    
    NSLog(@"This method fired: reloadMapView");
    
}

#pragma Dealing With Buttons for Navigation Bar

- (void) listPressed:(UIBarButtonItem *)sender {

    [self.navigationController pushViewController:self.locationsVC animated:YES];
    
    NSLog(@"This method ran: listPressed");
}

- (void) searchPressed:(UIBarButtonItem *)sender {
    
    [self.navigationController pushViewController:self.searchVC animated:YES];
    
    NSLog(@"This method ran: searchPressed");
}

- (void) categoryPressed:(UIBarButtonItem *)sender {
    
    if (self.yOriginCategoryView <= self.yOriginBackgroundView) {
        [self createCategoryView];
//        self.categoryVC.transitioningDelegate = self;
//        self.categoryVC.modalPresentationStyle = UIModalPresentationCustom;
    } else {
        [self dismissCategoryView];
    };
    
//    [self.navigationController pushViewController:self.categoryVC animated:YES];
    
    NSLog(@"This method ran: categoryPressed");
}

- (void) refreshCurrentLocationPressed:(UIBarButtonItem *)sender {
    
    [self mapView:self.mapView didUpdateUserLocation:self.mapView.userLocation];
    
    NSLog(@"This method ran: refreshCurrentLocationPressed");
}

- (void) createButtons {
    
    self.listButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:listImage]
                                                          style:UIBarButtonItemStylePlain
                                                         target:self
                                                         action:@selector(listPressed:)];
    
    self.categoryButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:categoryImage]
                                                          style:UIBarButtonItemStylePlain
                                                         target:self
                                                         action:@selector(categoryPressed:)];
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchPressed:)];
    
    self.navigationItem.leftBarButtonItem = self.listButton;
    self.navigationItem.rightBarButtonItems = @[self.categoryButton, searchButton];
    
    self.refreshCurrentLocationButton = [[UIButton alloc] init];
    
    UIImage *resetLocationImage = [UIImage imageNamed:currentLocationImage];
    [self.refreshCurrentLocationButton setImage:resetLocationImage forState:UIControlStateNormal];
//    self.refreshCurrentLocationButton.backgroundColor = [UIColor cyanColor];
    
    [self.refreshCurrentLocationButton addTarget:self action:@selector(refreshCurrentLocationPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.mapView addSubview:self.refreshCurrentLocationButton];
    
    NSLog(@"This method ran: createButtons");
}

- (void) createCategoryView {
    
    //Create Transparent Gray Background
    
    MKMapRect worldRect = MKMapRectWorld;
    MKMapPoint point1 = MKMapRectWorld.origin;
    MKMapPoint point2 = MKMapPointMake(point1.x+worldRect.size.width,point1.y);
    MKMapPoint point3 = MKMapPointMake(point2.x, point2.y+worldRect.size.height);
    MKMapPoint point4 = MKMapPointMake(point1.x, point3.y);
    
    MKMapPoint points[4] = {point1,point2,point3,point4};
    self.transparentGreyPolygon = [MKPolygon polygonWithPoints:points count:4];
    
    [self.mapView addOverlay:self.transparentGreyPolygon];
    
    
    CGFloat widthPadding = 30;
    CGFloat heightPadding = 60;
    
    CGFloat categoryViewWidth = self.mapView.frame.size.width - widthPadding - widthPadding;
    
    CGFloat categoryViewHeight = MIN([BSDataSource sharedInstance].headerHeight + [BSDataSource sharedInstance].cellHeight*[[BSDataSource sharedInstance].categoryItems count], [BSDataSource sharedInstance].headerHeight + [BSDataSource sharedInstance].cellHeight*5);
    
    self.categoryTableView.frame = CGRectMake(widthPadding, heightPadding - 1000, categoryViewWidth, categoryViewHeight);
    
    self.categoryTableView.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"The category view frame is xOrigin %f, yOrigin %f, width %f, height %f", CGRectGetMinX(self.categoryTableView.frame), CGRectGetMinY(self.categoryTableView.frame), self.categoryTableView.frame.size.width, self.categoryTableView.frame.size.height);
    
    // 1.5 second long duration of animation,
//    [UIView animateWithDuration:1.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options: 0 animations:^{
    [UIView animateWithDuration:0.5 delay:0 options: 0 animations:^{
        // this new value will drop it down with the spring damping (you can use the regular animateWithDuration method to do without that effect) to 200 below the top edge
        
        self.categoryTableView.frame = CGRectMake(widthPadding, heightPadding, categoryViewWidth, categoryViewHeight);
        
    } completion: nil];
    
    // alternatively, you can nest some more animations in the completion or whatever you want so that more things happen as soon it completes.
    
    self.yOriginCategoryView = CGRectGetMinY(self.categoryTableView.frame);
    self.yOriginBackgroundView = CGRectGetMinY(self.view.frame);
    
    NSLog(@"This method ran: createCategoryView");
    NSLog(@"The category view frame is xOrigin %f, yOrigin %f, width %f, height %f", CGRectGetMinX(self.categoryTableView.frame), CGRectGetMinY(self.categoryTableView.frame), self.categoryTableView.frame.size.width, self.categoryTableView.frame.size.height);
}

- (void) reloadCategoryView:(NSNotification *)notification {
    
    
    CGFloat widthPadding = 30;
    CGFloat heightPadding = 60;
    
    CGFloat categoryViewWidth = self.mapView.frame.size.width - widthPadding - widthPadding;
    
    CGFloat categoryViewHeight = MIN([BSDataSource sharedInstance].headerHeight + [BSDataSource sharedInstance].cellHeight*[[BSDataSource sharedInstance].categoryItems count], [BSDataSource sharedInstance].headerHeight + [BSDataSource sharedInstance].cellHeight*5);
    
    self.categoryTableView.frame = CGRectMake(widthPadding, heightPadding, categoryViewWidth, categoryViewHeight);
    
    //Scroll to bottom of tableview
    CGPoint offset = CGPointMake(0, self.categoryTableView.contentSize.height -     self.categoryTableView.frame.size.height);
    [self.categoryTableView setContentOffset:offset animated:YES];
    
    NSLog(@"This method fired: reloadCategoryView");
    
}

-(void)dismissCategoryView {
    
    
    if (self.yOriginCategoryView > self.yOriginBackgroundView) {
        [UIView animateWithDuration:1.5 delay:0 options: 0 animations:^{
            self.categoryTableView.frame = CGRectMake(CGRectGetMidX(self.mapView.frame) - CGRectGetWidth(self.categoryTableView.frame) / 2, CGRectGetMinY(self.mapView.frame) - 1000, 200, 200);
            
            //Dismiss Transparent Gray Background
            [self.mapView removeOverlay:self.transparentGreyPolygon];
            
        } completion: nil];
    }
    self.yOriginCategoryView = CGRectGetMinY(self.categoryTableView.frame);
    self.yOriginBackgroundView = CGRectGetMinY(self.view.frame);
    
    
    
    NSLog(@"This method ran: dismissCategoryView");
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if (![overlay isKindOfClass:[MKPolygon class]]) {
        return nil;
    }
    MKPolygon *polygon = (MKPolygon *)overlay;
    MKPolygonRenderer *renderer = [[MKPolygonRenderer alloc] initWithPolygon:polygon];
    renderer.fillColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.7];
    return renderer;
}

#pragma mark - MKAnnotationView

//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
- (MKAnnotationViewSubclass *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    else if ([annotation isKindOfClass:[MKPlacemark class]]) // use whatever annotation class you used when creating the annotation
    {
        static NSString * const identifier = @"MyCustomAnnotation";
        
//        MKAnnotationView* annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
//        
//        if (annotationView)
//        {
//            annotationView.annotation = annotation;
//        }
//        else
//        {
//            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
//                                                          reuseIdentifier:identifier];
//        }
//        
//        annotationView.canShowCallout = NO;
//        annotationView.image = [UIImage imageNamed:annotationImage];
//        
//        return annotationView;
        
        self.MKAnnotationViewSubclass = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (self.MKAnnotationViewSubclass)
        {
            self.MKAnnotationViewSubclass.annotation = annotation;
        }
        else
        {
            self.MKAnnotationViewSubclass = [[MKAnnotationViewSubclass alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:identifier];
        }
        
        self.MKAnnotationViewSubclass.canShowCallout = NO;
        self.MKAnnotationViewSubclass.image = [UIImage imageNamed:annotationImage];
        
        return self.MKAnnotationViewSubclass;

    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationViewSubclass *)view
{

    [view addSubview:self.annotationCalloutView];
    
}

@end
