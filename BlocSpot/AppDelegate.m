//
//  AppDelegate.m
//  BlocSpot
//
//  Created by Philip Sopher on 8/21/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "AppDelegate.h"
#import "BSLocationsTableViewController.h"
#import "BSMapViewController.h"
#import "BSLocationTracker.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[BSMapViewController alloc] init]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    
    UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
    if (notification) {
        [self messageNotification:notification.alertBody];
        NSLog(@"AppDelegate didFinishLaunchingWithOptions");
    }
    
    application.applicationIconBadgeNumber = 0;
    
    [self.window makeKeyAndVisible];
    
    //for location running in background
//    UIAlertView * alert;
//    
//    //We have to make sure that the Background App Refresh is enable for the Location updates to work in the background.
//    if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusDenied){
//        
//        alert = [[UIAlertView alloc]initWithTitle:@""
//                                          message:@"The app doesn't work without the Background App Refresh enabled. To turn it on, go to Settings > General > Background App Refresh"
//                                         delegate:nil
//                                cancelButtonTitle:@"Ok"
//                                otherButtonTitles:nil, nil];
//        [alert show];
//        
//    }else if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusRestricted){
//        
//        alert = [[UIAlertView alloc]initWithTitle:@""
//                                          message:@"The functions of this app are limited because the Background App Refresh is disable."
//                                         delegate:nil
//                                cancelButtonTitle:@"Ok"
//                                otherButtonTitles:nil, nil];
//        [alert show];
//        
//    } else{
//        
//        self.locationTracker = [[BSLocationTracker alloc]init];
//        [self.locationTracker startLocationTracking];
//        
//        //Send the best location to server every 60 seconds
//        //You may adjust the time interval depends on the need of your app.
//        NSTimeInterval time = 60.0;
//        self.locationUpdateTimer =
//        [NSTimer scheduledTimerWithTimeInterval:time
//                                         target:self
//                                       selector:@selector(updateLocation)
//                                       userInfo:nil
//                                        repeats:YES];
//    }
    
    return YES;
}

-(void)updateLocation {
    NSLog(@"updateLocation");
    
    [self.locationTracker updateLocationToServer];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    //We have to make sure that the Background App Refresh is enable for the Location updates to work in the background.
    UIAlertView * alert;
    
    if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusDenied){
        
        alert = [[UIAlertView alloc]initWithTitle:@""
                                          message:@"The app doesn't work without the Background App Refresh enabled. To turn it on, go to Settings > General > Background App Refresh"
                                         delegate:nil
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil, nil];
        [alert show];
        
    }else if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusRestricted){
        
        alert = [[UIAlertView alloc]initWithTitle:@""
                                          message:@"The functions of this app are limited because the Background App Refresh is disable."
                                         delegate:nil
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil, nil];
        [alert show];
        
    } else{
        
        self.locationTracker = [[BSLocationTracker alloc]init];
        [self.locationTracker startLocationTracking];
        
        //Send the best location to server every 60 seconds
        //You may adjust the time interval depends on the need of your app.
        NSTimeInterval time = 60.0;
        self.locationUpdateTimer =
        [NSTimer scheduledTimerWithTimeInterval:time
                                         target:self
                                       selector:@selector(updateLocation)
                                       userInfo:nil
                                        repeats:YES];
    }

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//Call The method below for notifications to fire when app is running in foreground

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    //Call The method below for notifications to fire when app is running in foreground
    //    [self messageNotification:notification.alertBody];
    
    
    application.applicationIconBadgeNumber = 0; //resets badge icon to zero if the message is received when app is in foreground
    //    NSLog(@"AppDelegate didReceiveLocalNotification %@", notification.userInfo);
}

- (void)messageNotification:(NSString *)text {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"BlocSpot"
                                                        message:text delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

@end
