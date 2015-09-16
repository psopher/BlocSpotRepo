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

@property (nonatomic, strong) MKPlacemark* annotation;

@property (nonatomic, strong) UIView* headerView;
@property (nonatomic, strong) UITextView* textView;
@property (nonatomic, strong) UIView* buttonsView;

@property (nonatomic, strong) UIButton* heartButton;
@property (nonatomic, strong) UIButton* directionsButton;
@property (nonatomic, strong) UIButton* shareButton;
@property (nonatomic, strong) UIButton* trashButton;

- (instancetype) init;

@end
