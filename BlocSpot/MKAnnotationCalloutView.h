//
//  MKAnnotationViewController.h
//  BlocSpot
//
//  Created by Philip Sopher on 9/15/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>

@interface MKAnnotationCalloutView : UIView

//@property (nonatomic, strong) id <MKAnnotation> annotation;
@property (nonatomic, strong) MKPlacemark* annotation;

@end
