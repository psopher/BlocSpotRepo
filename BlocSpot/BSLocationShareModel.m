//
//  BSLocationShareModel.m
//  BlocSpot
//
//  Created by Philip Sopher on 9/30/15.
//  Copyright © 2015 Bloc. All rights reserved.
//

#import "BSLocationShareModel.h"
#import "BSBackgroundTaskManager.h"

@implementation BSLocationShareModel

//Class method to make sure the share model is synch across the app
+ (id)sharedModel
{
    static id sharedMyModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyModel = [[self alloc] init];
    });
    return sharedMyModel;
}

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}


@end
