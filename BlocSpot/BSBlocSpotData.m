//
//  BSBlocSpotData.m
//  BlocSpot
//
//  Created by Philip Sopher on 9/20/15.
//  Copyright © 2015 Bloc. All rights reserved.
//

#import "BSBlocSpotData.h"

@implementation BSBlocSpotData

-(id)initWithCoder:(NSCoder *)aDecoder
{
    
    NSString *blocSpotName = [aDecoder decodeObjectForKey:@"blocSpotName"];
    NSAttributedString *blocSpotCategory = [aDecoder decodeObjectForKey:@"blocSpotCategory"];
    UIColor *blocSpotColor = [aDecoder decodeObjectForKey:@"blocSpotColor"];
    NSString *blocSpotNotes = [aDecoder decodeObjectForKey:@"blocSpotNotes"];
    
    CLLocationDegrees blocSpotCoordinatesLatitude = [aDecoder decodeDoubleForKey:@"blocSpotCoordinatesLatitude"];
    CLLocationDegrees blocSpotCoordinatesLongitude = [aDecoder decodeDoubleForKey:@"blocSpotCoordinatesLongitude"];
    CLLocationCoordinate2D blocSpotCoordinates = CLLocationCoordinate2DMake(blocSpotCoordinatesLatitude, blocSpotCoordinatesLongitude);
    
    CLLocationDistance blocSpotDistance = [aDecoder decodeDoubleForKey:@"blocSpotDistance"];
    
    BOOL blocSpotVisited = [aDecoder decodeBoolForKey:@"blocSpotVisited"];
    
    return [self initWithBlocSpotName:blocSpotName blocSpotCategory:blocSpotCategory blocSpotColor:blocSpotColor blocSpotNotes:blocSpotNotes blocSpotCoordinates:blocSpotCoordinates blocSpotDistance:blocSpotDistance blocSpotVisited:blocSpotVisited];
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:self.blocSpotName forKey:@"blocSpotName"];
    [aCoder encodeObject:self.blocSpotCategory forKey:@"blocSpotCategory"];
    [aCoder encodeObject:self.blocSpotColor forKey:@"blocSpotColor"];
    [aCoder encodeObject:self.blocSpotNotes forKey:@"blocSpotNotes"];
    
    [aCoder encodeDouble:self.blocSpotCoordinates.latitude forKey:@"blocSpotCoordinatesLatitude"];
    [aCoder encodeDouble:self.blocSpotCoordinates.longitude forKey:@"blocSpotCoordinatesLongitude"];
    
    [aCoder encodeDouble:self.blocSpotDistance forKey:@"blocSpotDistance"];
    
    [aCoder encodeBool:self.blocSpotVisited forKey:@"blocSpotVisited"];
    
}

-(instancetype)initWithBlocSpotName:(NSString *)blocSpotName blocSpotCategory:(NSAttributedString *)blocSpotCategory blocSpotColor:(UIColor *)blocSpotColor blocSpotNotes:(NSString *)blocSpotNotes blocSpotCoordinates:(CLLocationCoordinate2D)blocSpotCoordinates blocSpotDistance:(CLLocationDistance)blocSpotDistance blocSpotVisited:(BOOL)blocSpotVisited;
{
    self = [super init];
    
    if (self) {
        self.blocSpotName = blocSpotName;
        self.blocSpotCategory = blocSpotCategory;
        self.blocSpotColor = blocSpotColor;
        self.blocSpotNotes = blocSpotNotes;
        self.blocSpotCoordinates = blocSpotCoordinates;
        self.blocSpotDistance = blocSpotDistance;
        self.blocSpotVisited = blocSpotVisited;
    }
    return self;
}

-(instancetype) init{
    
    self.blocSpotName = [NSString new];
    self.blocSpotCategory = [NSAttributedString new];
    self.blocSpotColor = [UIColor new];
    self.blocSpotNotes = [NSString new];
    
    return self;
}

@end
