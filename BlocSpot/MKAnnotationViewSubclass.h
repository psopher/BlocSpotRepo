//
//  MKAnnotationViewSubclass.h
//  BlocSpot
//
//  Created by Philip Sopher on 9/15/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import <MapKit/MapKit.h>

@class MKAnnotationCalloutView;

@interface MKAnnotationViewSubclass : MKAnnotationView

@property (strong, nonatomic) MKAnnotationCalloutView *annotationCallout;


@end
