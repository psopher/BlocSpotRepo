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

@interface BSDataSource : NSObject

+(instancetype) sharedInstance;
- (void) saveToDisk;

@property MKMapView *mapViewCurrent;
@property MKCoordinateRegion *mapViewCurrentRegion;

@end
