//
//  BSDataSource.h
//  BlocSpot
//
//  Created by Philip Sopher on 8/26/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManager.h>
#import <AddressBook/AddressBook.h>

@class BSCategoryData;

@interface BSDataSource : NSObject

+(instancetype) sharedInstance;
- (void) saveToDisk;

- (void) deleteCategoryItem:(BSCategoryData *)item;
- (void) addCategoryItem:(BSCategoryData *)item;
- (void) replaceCategoryItem:(BSCategoryData *)item index:(NSInteger )index;


@property (strong, nonatomic) NSMutableArray *categoryItems;
@property (strong, nonatomic) BSCategoryData *categories;
@property (nonatomic, strong) NSArray *colors;

@property MKMapView *mapViewCurrent;
@property MKCoordinateRegion *mapViewCurrentRegion;

@property (nonatomic) CGFloat headerHeight;
@property (nonatomic) CGFloat cellHeight;

@end
