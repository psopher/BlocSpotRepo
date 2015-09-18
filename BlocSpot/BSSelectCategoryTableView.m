//
//  BSSelectCategoryTableView.m
//  BlocSpot
//
//  Created by Philip Sopher on 9/17/15.
//  Copyright © 2015 Bloc. All rights reserved.
//

#import "BSSelectCategoryTableView.h"
#import "BSDataSource.h"

@implementation BSSelectCategoryTableView

- (instancetype) init {
    
    self = [super init];
    
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
    }
    
    return self;
}

- (void)viewDidLoad
{
    
    [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"categoryCell"];
    
    NSLog(@"This Method was called: BSSelectCategoryTableView viewDidLoad");
}


#pragma TableView DataSource and Delegate Methods

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSLog(@"the number of cells is %lu", (unsigned long)[[BSDataSource sharedInstance].categoryItems count]);
    
    NSLog(@"This Method was called: BSSelectCategoryTableView numberOfRowsInSection");
    
    return [[BSDataSource sharedInstance].categoryItems count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"the height of cells is %lu", (unsigned long)[BSDataSource sharedInstance].selectCategoryCellHeight);
    
    NSLog(@"This Method was called: BSSelectCategoryTableView heightForRowAtIndexPath");
    
    return [BSDataSource sharedInstance].selectCategoryCellHeight;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [super cellForRowAtIndexPath:indexPath];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"categoryCell"];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"categoryCell"];
    }
    
    [cell.textLabel setText:[BSDataSource sharedInstance].categoryItems[indexPath.row]];
    
    NSInteger i = indexPath.row % 5;
    
    if (i == 0) {
        cell.contentView.backgroundColor = [BSDataSource sharedInstance].colors[i];
    } else if (i == 1) {
        cell.contentView.backgroundColor = [BSDataSource sharedInstance].colors[i];
    } else if (i == 2) {
        cell.contentView.backgroundColor = [BSDataSource sharedInstance].colors[i];
    } else if (i == 3) {
        cell.contentView.backgroundColor = [BSDataSource sharedInstance].colors[i];
    } else if (i == 4) {
        cell.contentView.backgroundColor = [BSDataSource sharedInstance].colors[i];
    }
    
    
    NSLog(@"This Method was called: BSSelectCategoryTableView cellForRowAtIndexPath");
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell* cellCheck = [tableView
                                  cellForRowAtIndexPath:indexPath];
    
    if (cellCheck.accessoryType == UITableViewCellAccessoryNone) {
        cellCheck.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cellCheck.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cellCheck.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSLog(@"This Method was called: BSSelectCategoryTableView didSelectRowAtIndexPath");
}

@end
