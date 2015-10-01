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
#import "BSSelectCategoryTableView.h"
#import "BSBlocSpotData.h"
#import "BSLocationTracker.h"

#define categoryImage @"category"
#define listImage @"list"
#define currentLocationImage @"globe"
#define annotationImage @"heart"
#define visitedImage @"visited"

#define LATITUDE @"latitude"
#define LONGITUDE @"longitude"
#define ACCURACY @"theAccuracy"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface BSMapViewController () <UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) BSLocationsTableViewController *locationsVC;
@property (strong, nonatomic) BSSearchTableViewController *searchVC;
@property (strong, nonatomic) BSCategoryTableView *categoryVC;
@property (nonatomic) CGFloat yOriginCategoryView;
@property (nonatomic) CGFloat yOriginBackgroundView;
@property (strong, nonatomic) MKPolygon *transparentGreyPolygon;
@property (strong, nonatomic) MKAnnotationViewSubclass *MKAnnotationViewSubclass;
@property (strong, nonatomic) MKAnnotationCalloutView* annotationCalloutView;
@property (assign, nonatomic) CGPoint calloutStartPoint;
@property (strong, nonatomic) MKRoute *walkingRoute;

@property (strong, nonatomic) UILabel *destinationLabel;
@property (strong, nonatomic) UILabel *distanceLabel;
@property (strong, nonatomic) UITextView *steps;
@property (nonatomic, strong) UIButton *clearDirectionsButton;
@property (strong, nonatomic) NSString *allSteps;

@property (assign, nonatomic) CLLocationDistance distance;

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
        
        self.walkingRoute = [[MKRoute alloc] init];
        self.walkingRoute = nil;
        self.destinationLabel = [[UILabel alloc] init];
        self.distanceLabel = [[UILabel alloc] init];
        self.steps = [[UITextView alloc] init];
        self.clearDirectionsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.allSteps = [[NSString alloc] init];
    }
    
    
    [self.mapView addSubview:self.categoryTableView];
    
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    
//    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager = [BSLocationTracker sharedLocationManager];
    self.locationManager.delegate = self;

    if(IS_OS_8_OR_LATER) {
        // Use one or the other, not both. Depending on what you put in info.plist
//        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
    }
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.distanceFilter = 50;
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadCustomCallout:)name:@"categoryChanged"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(removeAnnotationFromMap:)name:@"removeAnnotation"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(directionsFromUserLocation:)name:@"directionsFromUserLocation"
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
    
    
    
    self.calloutStartPoint = CGPointMake(self.mapView.bounds.size.width/10, self.mapView.bounds.size.height/10);
    self.annotationCalloutView.frame = CGRectMake(self.calloutStartPoint.x, self.calloutStartPoint.y, (self.mapView.bounds.size.width/5)*4, (self.mapView.bounds.size.height/2) - self.calloutStartPoint.y);
    self.annotationCalloutView.backgroundColor = [UIColor lightGrayColor];
    
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
    
    //Getting distance from annotations
    if (mapView.selectedAnnotations.count == 0)
        //no annotation is currently selected
        [self updateDistanceToAnnotation:nil];
    else
        //first object in array is currently selected annotation
        [self updateDistanceToAnnotation:[mapView.selectedAnnotations objectAtIndex:0]];
    
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
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"locationsListReload"
                                                            object:nil];
    });

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
    } else {
        [self dismissCategoryView];
    };
    
//    [self.navigationController pushViewController:self.categoryVC animated:YES];
    
    NSLog(@"This method ran: categoryPressed");
}

- (void) refreshCurrentLocationPressed:(UIBarButtonItem *)sender {
    
    [self mapView:self.mapView didUpdateUserLocation:self.mapView.userLocation];
    
    if (self.annotationCalloutView) {
        [self.annotationCalloutView removeFromSuperview];
    }
    
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

- (void) reloadCustomCallout:(NSNotification *)notification {

    
    self.annotationCalloutView.selectCategoryButton.backgroundColor = [BSDataSource sharedInstance].colors[[BSDataSource sharedInstance].selectedCategoryIndex];
    
    NSString *baseString = [NSString stringWithFormat:@"%@", [BSDataSource sharedInstance].categoryItems[[BSDataSource sharedInstance].selectedCategoryIndex]];
    NSRange range = [baseString rangeOfString:baseString];
    NSMutableAttributedString *selectCategoryString = [[NSMutableAttributedString alloc] initWithString:baseString];
    [selectCategoryString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:11] range:range];
    [selectCategoryString addAttribute:NSKernAttributeName value:@1.3 range:range];
    [self.annotationCalloutView.selectCategoryButton setAttributedTitle:selectCategoryString forState:UIControlStateNormal];
    
    self.annotationCalloutView.selectCategoryTableView.frame = CGRectMake(0, 0, 0, 0);
    
    [BSDataSource sharedInstance].blocSpotData.blocSpotCategory = self.annotationCalloutView.selectCategoryButton.currentAttributedTitle;
    [BSDataSource sharedInstance].blocSpotData.blocSpotColor = self.annotationCalloutView.selectCategoryButton.backgroundColor;
    [BSDataSource sharedInstance].blocSpotDataMutableDictionary[self.annotationCalloutView.headerLabel.text] = [BSDataSource sharedInstance].blocSpotData;
    
    NSMutableArray *blocSpotsMutableArray = [[NSMutableArray alloc] initWithArray:[[BSDataSource sharedInstance].blocSpotDataMutableDictionary allValues]];
    [BSDataSource sharedInstance].blocSpotDataMutableArray = blocSpotsMutableArray;
    
    NSLog(@"This method fired: reloadCustomCallout");
}

- (void) removeAnnotationFromMap:(NSNotification *)notification {
    
    [self.mapView removeAnnotation:self.MKAnnotationViewSubclass.annotation];
    
    NSLog(@"This method fired: removeAnnotationFromMap");
}

- (void) directionsFromUserLocation:(NSNotification *)notification {
    
    MKDirectionsRequest *walkingRouteRequest = [[MKDirectionsRequest alloc] init];
    walkingRouteRequest.transportType = MKDirectionsTransportTypeWalking;
    
    MKPlacemark *startPlacemark = [[MKPlacemark alloc] initWithCoordinate:self.mapView.userLocation.location.coordinate addressDictionary:nil];
    MKMapItem *startPoint = [[MKMapItem alloc] initWithPlacemark:startPlacemark];
    [walkingRouteRequest setSource:startPoint];
    
    MKPlacemark *endPlacemark = [[MKPlacemark alloc] initWithCoordinate:[BSDataSource sharedInstance].blocSpotData.blocSpotCoordinates addressDictionary:nil];
    MKMapItem *endPoint = [[MKMapItem alloc] initWithPlacemark:endPlacemark];
    [walkingRouteRequest setDestination:endPoint];
    
    MKDirections *walkingRouteDirections = [[MKDirections alloc] initWithRequest:walkingRouteRequest];
    [walkingRouteDirections calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * walkingRouteResponse, NSError *walkingRouteError) {
        if (walkingRouteError) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Walking Route Error",nil)
                                        message:[walkingRouteError localizedDescription]
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil] show];
        } else {
            [self.mapView addSubview:self.destinationLabel];
            [self.mapView addSubview:self.distanceLabel];
            [self.mapView addSubview:self.steps];
            [self.mapView addSubview:self.clearDirectionsButton];
            
            self.walkingRoute = walkingRouteResponse.routes[0];
            [self.mapView addOverlay:self.walkingRoute.polyline];
            self.destinationLabel.text = self.annotationCalloutView.headerLabel.text;
            self.distanceLabel.text = [NSString stringWithFormat:@"%0.1f Miles", self.walkingRoute.distance/1609.344];
            self.allSteps = @"";
            for (int i = 0; i < self.walkingRoute.steps.count; i++) {
                MKRouteStep *step = [self.walkingRoute.steps objectAtIndex:i];
                NSString *newStep = step.instructions;
                self.allSteps = [self.allSteps stringByAppendingString:newStep];
                self.allSteps = [self.allSteps stringByAppendingString:@"\n\n"];
                self.steps.text = self.allSteps;
            }
            [self directionsLayoutSubviews];
        }
    }];
    
    NSLog(@"This method fired: directionsFromUserLocation");
}

- (void) directionsLayoutSubviews {
    
    CGFloat padding = 10;
    CGFloat labelWidth = self.mapView.frame.size.width - padding - padding;
    CGFloat labelHeight = 20;
    CGFloat textViewHeight= 100;
    CGFloat clearButtonWidth = 150;
    CGFloat clearButtonStartX = (self.mapView.frame.size.width - clearButtonWidth)/2;
    
    
//    self.destinationLabel.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.4];
    self.destinationLabel.backgroundColor = [UIColor clearColor];
    self.destinationLabel.textAlignment = NSTextAlignmentCenter;
    self.destinationLabel.frame = CGRectMake(padding, self.navigationController.navigationBar.frame.size.height + padding, labelWidth, labelHeight);
    
//    self.distanceLabel.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.4];
    self.distanceLabel.backgroundColor = [UIColor clearColor];
    self.distanceLabel.textAlignment = NSTextAlignmentCenter;
    self.distanceLabel.frame = CGRectMake(padding, CGRectGetMaxY(self.destinationLabel.frame) + padding, labelWidth, labelHeight);
    
    self.steps.backgroundColor= [[UIColor lightGrayColor]colorWithAlphaComponent:0.4];
    self.steps.frame = CGRectMake(padding, CGRectGetMaxY(self.distanceLabel.frame) + padding, labelWidth, textViewHeight);
    self.steps.userInteractionEnabled = YES;
    
    self.clearDirectionsButton.backgroundColor = [[UIColor redColor]colorWithAlphaComponent:0.4];
//    self.clearDirectionsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.clearDirectionsButton.frame = CGRectMake(clearButtonStartX, CGRectGetMaxY(self.steps.frame) + padding, clearButtonWidth, labelHeight);
    NSMutableAttributedString *clearDirectionsString = [[NSMutableAttributedString alloc] initWithString:@"Clear Directions"];
    [self.clearDirectionsButton setAttributedTitle:clearDirectionsString forState:UIControlStateNormal];
    [self.clearDirectionsButton addTarget:self action:@selector(clearRoutePressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    NSLog(@"This method fired: directionsLayoutSubviews");
}

- (void) clearRoutePressed:(UIBarButtonItem *)sender {
    
    [self.destinationLabel removeFromSuperview];
    [self.distanceLabel removeFromSuperview];
    [self.steps removeFromSuperview];
    [self.clearDirectionsButton removeFromSuperview];
    
    [self.mapView removeOverlay:self.walkingRoute.polyline];
    
    self.walkingRoute = nil;
    
    NSLog(@"This method ran: clearRoutePressed");
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
    if (self.walkingRoute != nil) {
        MKPolylineRenderer  * routeLineRenderer = [[MKPolylineRenderer alloc] initWithPolyline:self.walkingRoute.polyline];
        routeLineRenderer.strokeColor = [UIColor redColor];
        routeLineRenderer.lineWidth = 5;
        return routeLineRenderer;
    } else {
        if (![overlay isKindOfClass:[MKPolygon class]]) {
            return nil;
        }
        MKPolygon *polygon = (MKPolygon *)overlay;
        MKPolygonRenderer *renderer = [[MKPolygonRenderer alloc] initWithPolygon:polygon];
        renderer.fillColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.7];
        return renderer;
    }
    
}

#pragma mark - MKAnnotationView

//- (MKAnnotationViewSubclass *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
- (MKAnnotationViewSubclass *)mapView:(MKMapView *)mapView viewForAnnotation:(MKPlacemark*)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    else if ([annotation isKindOfClass:[MKPointAnnotation class]]) // use whatever annotation class you used when creating the annotation
    {
        static NSString * const identifier = @"MyCustomAnnotation";
        
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
    
    if(![view.annotation isKindOfClass:[MKUserLocation class]]) {

        CGPoint touchPoint = view.center;
        CLLocationCoordinate2D location =
        [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
        [mapView setCenterCoordinate:location animated:YES];
        
        
        self.annotationCalloutView.headerLabel.text = [view.annotation title];
        
        NSLog(@"Annotation Header Text is: %@", self.annotationCalloutView.headerLabel.text);
        
        [view.superview addSubview:self.annotationCalloutView];
        
        [self updateDistanceToAnnotation:view.annotation];
        
        
        //Adding Data to Bloc Spot DataSource Dictionary
        BOOL doesContainKey = 0;
        NSArray *allKeys = [[BSDataSource sharedInstance].blocSpotDataMutableDictionary allKeys];
        doesContainKey = [allKeys containsObject:self.annotationCalloutView.headerLabel.text];
        
        if (doesContainKey == NO) {
            [BSDataSource sharedInstance].blocSpotData = [[BSBlocSpotData alloc] initWithBlocSpotName:self.annotationCalloutView.headerLabel.text blocSpotCategory:[BSDataSource sharedInstance].categoryItems[0] blocSpotColor:[BSDataSource sharedInstance].colors[0] blocSpotNotes:@" " blocSpotCoordinates:location blocSpotDistance:self.distance blocSpotVisited:NO];
            
            //Resetting Textview and Category and Visited
            UIImage* heartButtonImage = [UIImage imageNamed:annotationImage];
            [self.annotationCalloutView.heartButton setImage:heartButtonImage forState:UIControlStateNormal];
            self.annotationCalloutView.textView.text = nil;
            self.annotationCalloutView.selectCategoryButton.backgroundColor = [BSDataSource sharedInstance].colors[0];
            NSString *baseString = [NSString stringWithFormat:@"%@", [BSDataSource sharedInstance].categoryItems[0]];
            NSRange range = [baseString rangeOfString:baseString];
            NSMutableAttributedString *selectCategoryString = [[NSMutableAttributedString alloc] initWithString:baseString];
            [selectCategoryString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:11] range:range];
            [selectCategoryString addAttribute:NSKernAttributeName value:@1.3 range:range];
            [self.annotationCalloutView.selectCategoryButton setAttributedTitle:selectCategoryString forState:UIControlStateNormal];
            
            //Populating the Bloc Spots Array and Data Dictionary
            [[BSDataSource sharedInstance].blocSpotDataMutableDictionary setObject:[BSDataSource sharedInstance].blocSpotData forKey:[BSDataSource sharedInstance].blocSpotData.blocSpotName];
            
        } else {
            [BSDataSource sharedInstance].blocSpotData = [BSDataSource sharedInstance].blocSpotDataMutableDictionary[self.annotationCalloutView.headerLabel.text];
            
            
            //Resetting Textview and Category and Visited
            if ([BSDataSource sharedInstance].blocSpotData.blocSpotVisited == NO) {
                UIImage* heartButtonImage = [UIImage imageNamed:annotationImage];
                [self.annotationCalloutView.heartButton setImage:heartButtonImage forState:UIControlStateNormal];
            } else {
                UIImage* visitedButtonImage = [UIImage imageNamed:visitedImage];
                [self.annotationCalloutView.heartButton setImage:visitedButtonImage forState:UIControlStateNormal];
            }
            self.annotationCalloutView.textView.text = [BSDataSource sharedInstance].blocSpotData.blocSpotNotes;
            self.annotationCalloutView.selectCategoryButton.backgroundColor = [BSDataSource sharedInstance].blocSpotData.blocSpotColor;
            NSString *baseString = [NSString stringWithFormat:@"%@", [BSDataSource sharedInstance].blocSpotData.blocSpotCategory];
            NSRange range = [baseString rangeOfString:baseString];
            NSMutableAttributedString *selectCategoryString = [[NSMutableAttributedString alloc] initWithString:baseString];
            [selectCategoryString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:11] range:range];
            [selectCategoryString addAttribute:NSKernAttributeName value:@1.3 range:range];
            [self.annotationCalloutView.selectCategoryButton setAttributedTitle:selectCategoryString forState:UIControlStateNormal];
            
        }
        
        NSMutableArray *blocSpotsMutableArray = [[NSMutableArray alloc] initWithArray:[[BSDataSource sharedInstance].blocSpotDataMutableDictionary allValues]];
        [BSDataSource sharedInstance].blocSpotDataMutableArray = blocSpotsMutableArray;
        
        [self updateDistanceToAnnotation:view.annotation];

    }
    
    NSLog(@"This method ran: didSelectAnnotationView");
}

#pragma Getting Distance of annotation from user location

-(void)updateDistanceToAnnotation:(id<MKAnnotation>)annotation
{
    
    CLLocation *pinLocation = [[CLLocation alloc]
                               initWithLatitude:annotation.coordinate.latitude
                               longitude:annotation.coordinate.longitude];
    
    CLLocation *userLocation = [[CLLocation alloc]
                                initWithLatitude:self.mapView.userLocation.coordinate.latitude
                                longitude:self.mapView.userLocation.coordinate.longitude];
    
    self.distance = [pinLocation distanceFromLocation:userLocation]/1000;
    
    //Setting up local notifications if user is close
    
    if (self.distance <= 0.2){
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    
        NSDate *now = [NSDate date];
    
        localNotification.fireDate = now;
        localNotification.alertBody = [NSString stringWithFormat:@"You are within %0.1f km of %@", self.distance, annotation.title];
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
    
    NSLog(@"This method fired: updateDistanceToAnnotation");
}


@end
