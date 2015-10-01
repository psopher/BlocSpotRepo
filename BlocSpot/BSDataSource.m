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
        self.annotationsArray = [[[NSMutableArray alloc] init] mutableCopy];
        self.mapViewCurrent = [[MKMapView alloc] init];
        
        [self readFilesAtLaunch];
    }
    
    NSLog(@"This method ran: DataSource Init");
    
    return self;
}


#pragma Saving to Disk and Persisting Data

- (NSString *) pathForFilename:(NSString *) filename {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:filename];
    return dataPath;
}

- (void) saveToDisk{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSUInteger numberOfItemsToSave = self.blocSpotDataMutableArray.count;
        NSError *dataError;
        
        //Saving BlocSpots Array
        NSArray *blocSpotsToSaveArray = [self.blocSpotDataMutableArray subarrayWithRange:NSMakeRange(0, numberOfItemsToSave)];
        
        NSString *fullPathArray = [self pathForFilename:NSStringFromSelector(@selector(blocSpotDataMutableArray))];
        NSData *blocSpotsDataArray = [NSKeyedArchiver archivedDataWithRootObject:blocSpotsToSaveArray];
        
        BOOL wroteSuccessfullyArray = [blocSpotsDataArray writeToFile:fullPathArray options:NSDataWritingAtomic | NSDataWritingFileProtectionCompleteUnlessOpen error:&dataError];
        
        if (!wroteSuccessfullyArray) {
            NSLog(@"Couldn't write file: %@", dataError);
        }
        
        //Saving BlocSpots Dictionary
        NSDictionary *blocSpotsToSaveDictionary = self.blocSpotDataMutableDictionary;
        
        NSString *fullPathDictionary = [self pathForFilename:NSStringFromSelector(@selector(blocSpotDataMutableDictionary))];
        NSData *blocSpotsDataDictionary = [NSKeyedArchiver archivedDataWithRootObject:blocSpotsToSaveDictionary];
        
        BOOL wroteSuccessfullyDictionary = [blocSpotsDataDictionary writeToFile:fullPathDictionary options:NSDataWritingAtomic | NSDataWritingFileProtectionCompleteUnlessOpen error:&dataError];
        
        if (!wroteSuccessfullyDictionary) {
            NSLog(@"Couldn't write file: %@", dataError);
        }
        
        //Saving Annotations Array
//        NSArray *annotationsToSaveArray = [self.annotationsArray subarrayWithRange:NSMakeRange(0, numberOfItemsToSave)];
//        
//        NSString *fullPathAnnotationsArray = [self pathForFilename:NSStringFromSelector(@selector(annotationsArray))];
//        NSData *annotationsDataArray = [NSKeyedArchiver archivedDataWithRootObject:annotationsToSaveArray];
//        
//        BOOL wroteSuccessfullyAnnotationsArray = [annotationsDataArray writeToFile:fullPathAnnotationsArray options:NSDataWritingAtomic | NSDataWritingFileProtectionCompleteUnlessOpen error:&dataError];
//        
//        if (!wroteSuccessfullyAnnotationsArray) {
//            NSLog(@"Couldn't write file: %@", dataError);
//        }
    });
    
    NSLog(@"This method fired: saveToDisk");
}

- (void) readFilesAtLaunch {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //Reading BlocSpots Array
        NSString *fullPathArray = [self pathForFilename:NSStringFromSelector(@selector(blocSpotDataMutableArray))];
        NSArray *storedBlocSpotsArray = [NSKeyedUnarchiver unarchiveObjectWithFile:fullPathArray];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (storedBlocSpotsArray.count > 0) {
                NSMutableArray *mutableBlocSpotsArray = [storedBlocSpotsArray mutableCopy];
                
                self.blocSpotDataMutableArray = mutableBlocSpotsArray;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MCDidReceiveDataNotification" object:nil];
            }
        });
        
        //Reading BlocSpots Dictionary
        NSString *fullPathDictionary = [self pathForFilename:NSStringFromSelector(@selector(blocSpotDataMutableDictionary))];
        NSDictionary *storedBlocSpotsDictionary = [NSKeyedUnarchiver unarchiveObjectWithFile:fullPathDictionary];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (storedBlocSpotsArray.count > 0) {
                NSMutableDictionary *mutableBlocSpotsDictionary = [storedBlocSpotsDictionary mutableCopy];
                
                self.blocSpotDataMutableDictionary = mutableBlocSpotsDictionary;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MCDidReceiveDataNotification" object:nil];
            }
        });
        
        //Reading Annotations Array
        NSString *fullPathAnnotationsArray = [self pathForFilename:NSStringFromSelector(@selector(annotationsArray))];
        NSArray *storedAnnotationsArray = [NSKeyedUnarchiver unarchiveObjectWithFile:fullPathAnnotationsArray];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (storedAnnotationsArray.count > 0) {
                NSMutableArray *mutableAnnotationsArray = [storedAnnotationsArray mutableCopy];
                
                self.annotationsArray = mutableAnnotationsArray;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MCDidReceiveDataNotification" object:nil];
            }
        });
    });
    
    NSLog(@"This method fired: readFilesAtLaunch");
}

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
