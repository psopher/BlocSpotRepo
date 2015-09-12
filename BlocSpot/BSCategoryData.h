//
//  BSCategoryData.h
//  BlocSpot
//
//  Created by Philip Sopher on 9/10/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSCategoryData : NSObject <NSCoding>

@property (strong, nonatomic) NSMutableArray* categories;
@property (strong, nonatomic) NSString* categoryName;

-(instancetype)initWithCategoryName:(NSString *)categoryName categories:(NSMutableArray *)categories;

@end
