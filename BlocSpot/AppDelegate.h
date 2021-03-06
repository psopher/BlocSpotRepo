//
//  AppDelegate.h
//  BlocSpot
//
//  Created by Philip Sopher on 8/21/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BSLocationTracker;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property BSLocationTracker * locationTracker;
@property (nonatomic) NSTimer* locationUpdateTimer;

@end

