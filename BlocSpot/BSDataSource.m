//
//  BSDataSource.m
//  BlocSpot
//
//  Created by Philip Sopher on 8/26/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "BSDataSource.h"
#import "BSCategoryData.h"

@interface BSDataSource ()
{
    NSMutableArray *_categoryItems;
}
@end


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
        
//        self.categoryItems = [NSMutableArray new];
        self.mapViewCurrent = [[MKMapView alloc] init];
        
    }
    
    NSLog(@"This method ran: DataSource Init");
    
    return self;
}

- (void) saveToDisk {
    
    
    NSLog(@"This method ran: saveToDisk");
}

#pragma Saving to Disk and Persisting Data



#pragma mark - Key/Value Observing for Swipe to Delete

- (NSUInteger) countOfCategoryItems {
    
    return self.categoryItems.count;
}

- (id) objectInCategoryItemsAtIndex:(NSUInteger)index {
    return [self.categoryItems objectAtIndex:index];
}

- (NSArray *) categoryItemsAtIndexes:(NSIndexSet *)indexes {
    return [self.categoryItems objectsAtIndexes:indexes];
}

- (void) insertObject:(BSCategoryData *)object inCategoryItemsAtIndex:(NSUInteger)index {
    [_categoryItems insertObject:object atIndex:index];
}

- (void) removeObjectFromCategoryItemsAtIndex:(NSUInteger)index {
    [_categoryItems removeObjectAtIndex:index];
}

- (void) replaceObjectInCategoryItemsAtIndex:(NSUInteger)index withObject:(id)object {
    [_categoryItems replaceObjectAtIndex:index withObject:object];
}

- (void) deleteMediaItem:(BSCategoryData *)item {
    NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"categoryItems"];
    
    NSLog(@"The number of items in deleteMediaItem1 is: %lu", (unsigned long)self.categoryItems.count);
    
    [mutableArrayWithKVO removeObject:item];
    
    NSLog(@"The number of items in deleteMediaItem2 is: %lu", (unsigned long)self.categoryItems.count);
}

@end
