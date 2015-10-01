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

@class MKAnnotationViewSubclass;

@interface BSBlocSpotData : NSObject<NSCoding>

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSAttributedString* category;
@property (strong, nonatomic) UIColor* color;
@property (strong, nonatomic) NSString* notes;
@property (assign, nonatomic) CLLocationCoordinate2D coordinates;
@property (assign, nonatomic) CLLocationDistance distance;
@property (assign, nonatomic) BOOL visited;
//@property (strong, nonatomic) MKPointAnnotation* annotation;

//@property (strong, nonatomic) MKAnnotationViewSubclass *blocSpotAnnotation;

-(instancetype)initWithName:(NSString *)name category:(NSAttributedString *)category color:(UIColor *)color notes:(NSString *)notes coordinates:(CLLocationCoordinate2D)coordinates distance:(CLLocationDistance)distance visited:(BOOL)visited annotation:(MKPointAnnotation *)annotation;


@end
