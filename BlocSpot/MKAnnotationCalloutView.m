//
//  MKAnnotationViewController.m
//  BlocSpot
//
//  Created by Philip Sopher on 9/15/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "MKAnnotationCalloutView.h"

@implementation MKAnnotationCalloutView

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
