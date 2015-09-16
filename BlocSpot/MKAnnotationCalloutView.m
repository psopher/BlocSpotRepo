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
        
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        
        self.headerView = [[UIView alloc] init];
        self.headerView.backgroundColor = [UIColor whiteColor];
        self.textView = [[UITextView alloc] init];
        self.textView.backgroundColor = [UIColor whiteColor];
        self.buttonsView = [[UIView alloc] init];
        self.buttonsView.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.headerView];
        [self addSubview:self.textView];
        [self addSubview:self.buttonsView];
        
        self.heartButton = [[UIButton alloc] init];
        self.heartButtonImage = [UIImage imageNamed:heartImage];
        self.visitedButtonImage = [UIImage imageNamed:visitedImage];
        [self.heartButton setImage:self.heartButtonImage forState:UIControlStateNormal];
        
        [self.heartButton addTarget:self action:@selector(heartButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        self.directionsButton = [[UIButton alloc] init];
        UIImage *directionsButtonImage = [UIImage imageNamed:directionsImage];
        [self.directionsButton setImage:directionsButtonImage forState:UIControlStateNormal];
        [self.directionsButton addTarget:self action:@selector(directionsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        self.shareButton = [[UIButton alloc] init];
        UIImage *shareButtonImage = [UIImage imageNamed:shareImage];
        [self.shareButton setImage:shareButtonImage forState:UIControlStateNormal];
        [self.shareButton addTarget:self action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        self.trashButton = [[UIButton alloc] init];
        UIImage *trashButtonImage = [UIImage imageNamed:trashImage];
        [self.trashButton setImage:trashButtonImage forState:UIControlStateNormal];
        [self.trashButton addTarget:self action:@selector(trashButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.headerView addSubview:self.heartButton];
        [self.buttonsView addSubview:self.directionsButton];
        [self.buttonsView addSubview:self.shareButton];
        [self.buttonsView addSubview:self.trashButton];
        
    }

    return self;
}

- (void) layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat widthPadding = 5;
    CGFloat heightPadding = 5;
    CGFloat viewWidth = self.bounds.size.width - widthPadding - widthPadding;
    CGFloat headerHeight = self.bounds.size.height/5;
    CGFloat headerTextPadding = heightPadding*2;
    CGFloat textViewHeight = ((headerHeight-heightPadding)*3) - heightPadding;
    
    self.headerView.frame = CGRectMake(widthPadding, heightPadding, viewWidth, headerHeight);
    self.textView.frame = CGRectMake(widthPadding, self.headerView.frame.size.height + headerTextPadding, viewWidth, textViewHeight);
    self.buttonsView.frame = CGRectMake(widthPadding, headerHeight*4 - heightPadding, viewWidth, headerHeight);
    
    CGFloat directionsButtonStartX = self.buttonsView.bounds.size.width/2;
    CGFloat buttonPaddingY = 5;
    CGFloat buttonWidth = self.buttonsView.bounds.size.width/6;
    CGFloat buttonHeight= self.buttonsView.bounds.size.height - buttonPaddingY - buttonPaddingY;
    CGFloat shareButtonStartX = directionsButtonStartX + buttonWidth;
    CGFloat trashButtonStartX = shareButtonStartX + buttonWidth;
    
    self.directionsButton.frame = CGRectMake(directionsButtonStartX, buttonPaddingY, buttonWidth, buttonHeight);
    self.shareButton.frame = CGRectMake(shareButtonStartX, buttonPaddingY, buttonWidth, buttonHeight);
    self.trashButton.frame = CGRectMake(trashButtonStartX, buttonPaddingY, buttonWidth, buttonHeight);
    
    
    CGFloat heartButtonStartX = trashButtonStartX;
    CGFloat heartButtonWidth = self.headerView.bounds.size.width/6;
    CGFloat heartButtonHeight= self.headerView.bounds.size.height - buttonPaddingY - buttonPaddingY;
    
    self.heartButton.frame = CGRectMake(heartButtonStartX, buttonPaddingY, heartButtonWidth, heartButtonHeight);
    
}

#pragma Buttons Pressed

- (void) heartButtonPressed:(UIBarButtonItem *)sender {
    
//    if ([self.heartButton.imageView.image  isEqual: self.heartButtonImage]) {
//        UIImage *visitedButtonImage = [UIImage imageNamed:visitedImage];
//        [self.heartButton setImage:visitedButtonImage forState:UIControlStateNormal];
//    } else {
//        [self.heartButton setImage:self.heartButtonImage forState:UIControlStateNormal];
//    }
    
    if ([self.heartButton.imageView.image  isEqual: self.heartButtonImage]) {
        [self.heartButton setImage:self.visitedButtonImage forState:UIControlStateNormal];
    } else {
        [self.heartButton setImage:self.heartButtonImage forState:UIControlStateNormal];
    }
    
    NSLog(@"This method ran: heartButtonPressed");
}

- (void) directionsButtonPressed:(UIBarButtonItem *)sender {
    
    NSLog(@"This method ran: directionsButtonPressed");
}

- (void) shareButtonPressed:(UIBarButtonItem *)sender {
    
    NSLog(@"This method ran: shareButtonPressed");
}

- (void) trashButtonPressed:(UIBarButtonItem *)sender {
    
    NSLog(@"This method ran: trashButtonPressed");
}

#pragma Makes the callout disappear when a different spot on the map is tapped

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
    UIView* hitView = [super hitTest:point withEvent:event];
    if (hitView != self && hitView != self.headerView && hitView != self.textView && hitView != self.buttonsView && hitView != self.heartButton && hitView != self.directionsButton && hitView != self.shareButton && hitView != self.trashButton)
    {
        [self removeFromSuperview];
    }
    
    NSLog(@"This method ran: MKAnnotationCalloutView hitTest");
    
    return hitView;
}

@end
