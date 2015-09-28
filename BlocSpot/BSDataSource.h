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
@class BSBlocSpotData;

@interface BSDataSource : NSObject

+(instancetype) sharedInstance;
- (void) saveToDisk;

- (void) deleteCategoryItem:(BSCategoryData *)item;
- (void) addCategoryItem:(BSCategoryData *)item;
- (void) replaceCategoryItem:(BSCategoryData *)item index:(NSInteger )index;


@property (strong, nonatomic) NSMutableArray *categoryItems;
@property (strong, nonatomic) BSCategoryData *categories;
@property (nonatomic, strong) NSArray *colors;
@property (strong, nonatomic) NSMutableArray *blocSpots;
@property (strong, nonatomic) NSMutableArray *blocSpotDataMutableArray;
@property (strong, nonatomic) NSMutableDictionary *blocSpotDataMutableDictionary;
@property (nonatomic, strong) BSBlocSpotData *blocSpotData;

@property MKMapView *mapViewCurrent;
@property MKCoordinateRegion *mapViewCurrentRegion;

@property (nonatomic) CGFloat headerHeight;
@property (nonatomic) CGFloat cellHeight;

@property (nonatomic) CGFloat selectCategoryCellHeight;

@property (nonatomic, assign) NSInteger selectedCategoryIndex;

@end
