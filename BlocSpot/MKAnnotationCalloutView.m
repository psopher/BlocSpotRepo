//
//  MKAnnotationViewController.m
//  BlocSpot
//
//  Created by Philip Sopher on 9/15/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "MKAnnotationCalloutView.h"

#define directionsImage @"directions"
#define shareImage @"share"
#define trashImage @"trash"
#define heartImage @"heart"
#define visitedImage @"visited"

@implementation MKAnnotationCalloutView


- (instancetype) init {
    // First, call the superclass (UIView)'s initializer, to make sure we do all that setup first.
    self = [super init];
    
    if (self) {
        
        self.headerView = [[UIView alloc] init];
        self.headerView.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.7];
        self.textView = [[UITextView alloc] init];
        self.textView.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.7];
        self.buttonsView = [[UIView alloc] init];
        self.buttonsView.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.7];
        
        [self addSubview:self.headerView];
        [self addSubview:self.textView];
        [self addSubview:self.buttonsView];
        
    }

    return self;
}

- (void) layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat viewWidth = self.bounds.size.width;
    CGFloat headerHeight = self.bounds.size.height/5;
    CGFloat headerTextPadding = 1;
    CGFloat textViewHeight = (headerHeight*3) - headerTextPadding;
    
    self.headerView.frame = CGRectMake(0, 0, viewWidth, headerHeight);
    self.textView.frame = CGRectMake(0, self.headerView.frame.size.height + 1, viewWidth, textViewHeight);
    self.buttonsView.frame = CGRectMake(0, headerHeight*4, viewWidth, headerHeight);
    
    
    
}

#pragma Makes the callout disappear when a different spot on the map is tapped

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
    UIView* hitView = [super hitTest:point withEvent:event];
    if (hitView != self)
    {
        [self removeFromSuperview];
    }
    
    NSLog(@"This method ran: MKAnnotationCalloutView hitTest");
    
    return hitView;
}

@end
