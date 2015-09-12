//
//  BSCategoryData.m
//  BlocSpot
//
//  Created by Philip Sopher on 9/10/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "BSCategoryData.h"

@implementation BSCategoryData

-(id)initWithCoder:(NSCoder *)aDecoder
{
    NSString *categoryName = [aDecoder decodeObjectForKey:@"categoryName"];
    NSMutableArray *categories = [aDecoder decodeObjectForKey:@"categories"];
    
    
    return [self initWithCategoryName:categoryName categories:categories];
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.categoryName forKey:@"categoryName"];
    [aCoder encodeObject:self.categories forKey:@"categories"];
}

-(instancetype)initWithCategoryName:(NSString *)categoryName categories:(NSMutableArray *)categories;
{
    self = [super init];
    
    if (self) {
        self.categoryName = categoryName;
        self.categories = categories;
        
    }
    return self;
}

-(instancetype) init{
    
    self.categoryName = [NSString new];
    self.categories = [NSMutableArray new];
    
    return self;
}

@end
