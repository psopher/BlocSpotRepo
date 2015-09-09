//
//  BSCategoryTableViewController.h
//  BlocSpot
//
//  Created by Philip Sopher on 8/21/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSCategoryTableView : UITableView <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *_displayedObjects;
}

@property (nonatomic, retain) NSMutableArray *displayedObjects;

@end
