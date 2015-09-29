//
//  BSDataSource.m
//  BlocSpot
//
//  Created by Philip Sopher on 8/26/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "BSDataSource.h"
#import "BSCategoryData.h"
#import "BSBlocSpotData.h"

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
        
        self.categoryItems = [[[NSMutableArray alloc] init] mutableCopy];
        self.categories = [[BSCategoryData alloc] init];
        self.colors = [[NSArray alloc] init];
        self.blocSpotDataMutableArray = [[[NSMutableArray alloc] init] mutableCopy];
        self.blocSpotDataMutableDictionary = [[[NSMutableDictionary alloc] init] mutableCopy];
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

- (void) deleteCategoryItem:(BSCategoryData *)item {
    NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"categoryItems"];
    
    NSLog(@"The number of items in deleteCategoryItem1 is: %lu", (unsigned long)self.categoryItems.count);
    
    [mutableArrayWithKVO removeObject:item];
    
    NSLog(@"The number of items in deleteCategoryItem2 is: %lu", (unsigned long)self.categoryItems.count);
}

- (void) addCategoryItem:(BSCategoryData *)item {
    NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"categoryItems"];
    
    NSLog(@"The number of items in addCategoryItem1 is: %lu", (unsigned long)self.categoryItems.count);
    
    [mutableArrayWithKVO addObject:item.categoryName];
    
    NSLog(@"The number of items in addCategoryItem2 is: %lu", (unsigned long)self.categoryItems.count);
}

- (void) replaceCategoryItem:(BSCategoryData *)item index:(NSInteger )index{
    NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"categoryItems"];
    
    [mutableArrayWithKVO replaceObjectAtIndex:index withObject:item.categoryName];

}

@end
