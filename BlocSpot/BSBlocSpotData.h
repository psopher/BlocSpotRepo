//
//  BSBlocSpotData.h
//  BlocSpot
//
//  Created by Philip Sopher on 9/20/15.
//  Copyright © 2015 Bloc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManager.h>
#import <AddressBook/AddressBook.h>

@interface BSBlocSpotData : NSObject<NSCoding>

@property (strong, nonatomic) NSString* blocSpotName;
@property (strong, nonatomic) NSAttributedString* blocSpotCategory;
@property (strong, nonatomic) UIColor* blocSpotColor;
@property (strong, nonatomic) NSString* blocSpotNotes;
@property (assign, nonatomic) CLLocationCoordinate2D blocSpotCoordinates;
@property (assign, nonatomic) BOOL blocSpotVisited;

-(instancetype)initWithBlocSpotName:(NSString *)blocSpotName blocSpotCategory:(NSAttributedString *)blocSpotCategory blocSpotColor:(UIColor *)blocSpotColor blocSpotNotes:(NSString *)blocSpotNotes blocSpotCoordinates:(CLLocationCoordinate2D)blocSpotCoordinates blocSpotVisited:(BOOL)blocSpotVisited;


@end
