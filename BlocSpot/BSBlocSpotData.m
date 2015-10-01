//
//  BSBlocSpotData.m
//  BlocSpot
//
//  Created by Philip Sopher on 9/20/15.
//  Copyright © 2015 Bloc. All rights reserved.
//

#import "BSBlocSpotData.h"
#import "MKAnnotationViewSubclass.h"

@implementation BSBlocSpotData

-(id)initWithCoder:(NSCoder *)aDecoder
{
    
    NSString *name = [aDecoder decodeObjectForKey:@"name"];
    NSAttributedString *category = [aDecoder decodeObjectForKey:@"category"];
    UIColor *color = [aDecoder decodeObjectForKey:@"color"];
    NSString *notes = [aDecoder decodeObjectForKey:@"notes"];
    
    CLLocationDegrees coordinatesLatitude = [aDecoder decodeDoubleForKey:@"coordinatesLatitude"];
    CLLocationDegrees coordinatesLongitude = [aDecoder decodeDoubleForKey:@"coordinatesLongitude"];
    CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake(coordinatesLatitude, coordinatesLongitude);
    
    CLLocationDistance distance = [aDecoder decodeDoubleForKey:@"distance"];
    
    BOOL visited = [aDecoder decodeBoolForKey:@"visited"];
    
//    MKAnnotationViewSubclass *annotation = [aDecoder decodeObjectForKey:@"annotation"];
    
    return [self initWithName:name category:category color:color notes:notes coordinates:coordinates distance:distance visited:visited annotation:nil];
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.category forKey:@"category"];
    [aCoder encodeObject:self.color forKey:@"color"];
    [aCoder encodeObject:self.notes forKey:@"notes"];
    
    [aCoder encodeDouble:self.coordinates.latitude forKey:@"coordinatesLatitude"];
    [aCoder encodeDouble:self.coordinates.longitude forKey:@"coordinatesLongitude"];
    
    [aCoder encodeDouble:self.distance forKey:@"distance"];
    
    [aCoder encodeBool:self.visited forKey:@"visited"];
    
//    [aCoder encodeObject:self.annotation forKey:@"annotation"];
    
}

-(instancetype)initWithName:(NSString *)name category:(NSAttributedString *)category color:(UIColor *)color notes:(NSString *)notes coordinates:(CLLocationCoordinate2D)coordinates distance:(CLLocationDistance)distance visited:(BOOL)visited annotation:(MKPointAnnotation *)annotation
{
    self = [super init];
    
    if (self) {
        self.name = name;
        self.category = category;
        self.color = color;
        self.notes = notes;
        self.coordinates = coordinates;
        self.distance = distance;
        self.visited = visited;
//        self.annotation = annotation;
    }
    return self;
}

-(instancetype) init{
    
    self.name = [NSString new];
    self.category = [NSAttributedString new];
    self.color = [UIColor new];
    self.notes = [NSString new];
//    self.annotation = [MKPointAnnotation new];
    
    return self;
}

@end
