//
//  BSDataSource.m
//  BlocSpot
//
//  Created by Philip Sopher on 8/26/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "BSDataSource.h"

@implementation BSDataSource

+ (instancetype) sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype) init {
    self = [super init];
    
    if (self) {
        
        self.mapViewCurrent = [[MKMapView alloc] init];
        
    }
    
    NSLog(@"This method ran: DataSource Init");
    
    return self;
}

- (void) saveToDisk {
    
    
    NSLog(@"This method ran: saveToDisk");
}

@end
