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
- (void) deleteMediaItem:(BSCategoryData *)item;

@property (strong, nonatomic) NSMutableArray *categoryItems;

@property MKMapView *mapViewCurrent;
@property MKCoordinateRegion *mapViewCurrentRegion;

@property (nonatomic) CGFloat headerHeight;
@property (nonatomic) CGFloat cellHeight;
@property (nonatomic) CGFloat numberOfCells;

@end
