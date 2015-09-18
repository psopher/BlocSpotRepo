//
//  BSCategoryTableViewController.m
//  BlocSpot
//
//  Created by Philip Sopher on 8/21/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "BSCategoryTableView.h"
#import "BSDataSource.h"
#import "BSCategoryData.h"

#define addRowsImage @"plus"

@interface BSCategoryTableView ()

@property (nonatomic, strong) UITableViewHeaderFooterView *headerView;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, assign) NSIndexPath* replaceIndex;
//@property (nonatomic, strong) UITableViewCell *cell;

@end

@implementation BSCategoryTableView

static NSString *headerReuseIdentifier = @"TableViewSectionHeaderViewIdentifier";

- (instancetype) init {
    
    self = [super init];
    
    if (self) {
        
        self.dataSource = self;
        self.delegate = self;
        
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        
        NSMutableArray *categoriesArray = [@[@""] mutableCopy];
        NSString *noCategoryAssignedName = @"No Category Assigned";
        
        BSCategoryData *categoryDataArray = [[BSCategoryData alloc] initWithCategoryName:noCategoryAssignedName categories:categoriesArray];
        
        [BSDataSource sharedInstance].categories = categoryDataArray;
        
        [BSDataSource sharedInstance].categoryItems = [NSMutableArray new];
        [[BSDataSource sharedInstance].categoryItems addObject:[BSDataSource sharedInstance].categories.categoryName];
        
       
        NSMutableArray *categoriesArray2 = [@[@""] mutableCopy];
        NSString *CategoryAssignedNameRestaurants = @"Restaurants";
        
        BSCategoryData *categoryDataArray2 = [[BSCategoryData alloc] initWithCategoryName:CategoryAssignedNameRestaurants categories:categoriesArray2];
        
        [BSDataSource sharedInstance].categories = categoryDataArray2;
        
        [[BSDataSource sharedInstance].categoryItems addObject:[BSDataSource sharedInstance].categories.categoryName];
        
        NSLog(@"the category items array looks like this: %@", [BSDataSource sharedInstance].categoryItems);
        
        //Text Field for newly added cells
        self.textField = [[UITextField alloc] init];
        self.textField.returnKeyType = UIReturnKeyDone;
        self.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.textField.placeholder = NSLocalizedString(@"Type Category Name Here", @"Placeholder text for new category name");
        self.textField.backgroundColor = [UIColor colorWithWhite:220/255.0f alpha:1];
        self.textField.delegate = self;
        
        //Category colors array
        [BSDataSource sharedInstance].colors = @[[[UIColor redColor]colorWithAlphaComponent:0.7],
                                                 [[UIColor purpleColor]colorWithAlphaComponent:0.5],
                                                 [[UIColor blueColor]colorWithAlphaComponent:0.5],
                                                 [[UIColor orangeColor]colorWithAlphaComponent:0.5],
                                                 [[UIColor greenColor]colorWithAlphaComponent:0.5]];
    }
    
    return self;
}

- (void)viewDidLoad
{
    
    [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"categoryCell"];
    
    [[BSDataSource sharedInstance] addObserver:self forKeyPath:@"categoryItems" options:0 context:nil];
    
    NSLog(@"This Method was called: BSCategoryTableView viewDidLoad");
}

- (void) dealloc
{
    [[BSDataSource sharedInstance] removeObserver:self forKeyPath:@"categoryItems"];
}

#pragma TableView DataSource and Delegate Methods

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    self.headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerReuseIdentifier];
    
    self.headerView = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0,0,self.bounds.size.width,40)];
    
    CGFloat widthPadding = 12;
    CGFloat buttonWidth = 40;
    
    self.headerLabel = [[UILabel alloc] init];
    self.addButton = [[UIButton alloc] init];
    
    [self.headerView.contentView addSubview:self.headerLabel];
    [self.headerView.contentView addSubview:self.addButton];
                        
    self.headerLabel.frame = CGRectMake(widthPadding, 10, self.frame.size.width - buttonWidth - widthPadding, 20);
    self.headerLabel.text = @"Choose Category";
    self.headerLabel.backgroundColor = [UIColor clearColor];
    self.headerLabel.textColor=[UIColor blackColor];
    self.headerLabel.font = [UIFont boldSystemFontOfSize:15];
    
    //  Configure the Add button
    self.addButton.frame = CGRectMake(self.headerLabel.frame.size.width + widthPadding, 10, buttonWidth, self.headerLabel.frame.size.height);
    
    UIImage *addButtonImage = [UIImage imageNamed:addRowsImage];
    [self.addButton setImage:addButtonImage forState:UIControlStateNormal];
    
    [self.addButton addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
    
    self.addButton.backgroundColor = [UIColor clearColor];
    
    NSLog(@"This Method was called: BSCategoryTableView viewForHeaderInSection");
    
    return self.headerView;
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    
    [BSDataSource sharedInstance].headerHeight = 40;
    
    NSLog(@"This Method was called: BSCategoryTableView tableViewHeightForHeaderInSection");
    
    return [BSDataSource sharedInstance].headerHeight;
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    
    NSLog(@"This Method was called: BSCategoryTableView numberOfSectionsInTableView");
    
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSLog(@"the number of cells is %lu", (unsigned long)[[BSDataSource sharedInstance].categoryItems count]);
    
    NSLog(@"This Method was called: BSCategoryTableView numberOfRowsInSection");
    
    return [[BSDataSource sharedInstance].categoryItems count];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [super cellForRowAtIndexPath:indexPath];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"categoryCell"];
        
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"categoryCell"];
    }
    
    [cell.textLabel setText:[BSDataSource sharedInstance].categoryItems[indexPath.row]];
    
    
    CGFloat widthPadding = 10;
    CGFloat heightPadding = 5;
    
    if ([cell.textLabel.text  isEqual: @"New Category"]) {
        self.textField.frame=CGRectMake(widthPadding, heightPadding, cell.frame.size.width - widthPadding - widthPadding, cell.frame.size.height - heightPadding - heightPadding);
        
        self.replaceIndex = indexPath;
        
        [cell addSubview:self.textField];
    }
    
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


    NSLog(@"This Method was called: BSCategoryTableView cellForRowAtIndexPath");
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [BSDataSource sharedInstance].cellHeight = 60;
    
    return [BSDataSource sharedInstance].cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cellCheck = [tableView
                                  cellForRowAtIndexPath:indexPath];
    
    if (cellCheck.accessoryType == UITableViewCellAccessoryNone) {
        cellCheck.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cellCheck.accessoryType = UITableViewCellAccessoryNone;
    }
    
//    cellCheck.accessoryView.backgroundColor = cellCheck.backgroundColor;
    
    cellCheck.selectionStyle = UITableViewCellSelectionStyleNone;
}

#pragma Swipe to Delete Methods

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"The number of items in commitEditingStyle is: %lu", (unsigned long)[BSDataSource sharedInstance].categoryItems.count);
    NSLog(@"numberOfRowsInSection: %ld", (long)[self tableView:self numberOfRowsInSection:0]);
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //Getting rid of check mark accessory
        
        for (NSInteger i = indexPath.row; i < [[BSDataSource sharedInstance].categoryItems count]; i++) {
            NSIndexPath *currentIndex = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
            UITableViewCell* cellCheck = [tableView
                                          cellForRowAtIndexPath:currentIndex];
            
            NSIndexPath *nextIndex = [NSIndexPath indexPathForRow:i+1 inSection:indexPath.section];
            UITableViewCell* nextCell = [tableView
                                         cellForRowAtIndexPath:(nextIndex)];
            
            if (cellCheck.accessoryType == UITableViewCellAccessoryCheckmark && nextCell.accessoryType == UITableViewCellAccessoryNone) {
                cellCheck.accessoryType = UITableViewCellAccessoryNone;
            } else if (cellCheck.accessoryType == UITableViewCellAccessoryNone && nextCell.accessoryType == UITableViewCellAccessoryCheckmark) {
                cellCheck.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
        
        
        // Delete the row from the data source
        BSCategoryData *item = [BSDataSource sharedInstance].categoryItems[indexPath.row];
        [[BSDataSource sharedInstance] deleteCategoryItem:item];
        
       
//        NSInteger nextIndexInt = [indexPath indexAtPosition:indexPath.length+1];
        
        [self reloadData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"numberOfRowsChanged"
                                                                object:nil];
        });
    }
    
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == [BSDataSource sharedInstance] && [keyPath isEqualToString:@"categoryItems"]) {
            // We know categoryitems changed.  Let's see what kind of change it is.
            int kindOfChange = [change[NSKeyValueChangeKindKey] intValue];
        
            if (kindOfChange == NSKeyValueChangeSetting) {
                // Someone set a brand new images array
                [self reloadData];
            } else if (kindOfChange == NSKeyValueChangeInsertion ||
                       kindOfChange == NSKeyValueChangeRemoval ||
                       kindOfChange == NSKeyValueChangeReplacement) {
                // We have an incremental change: inserted, deleted, or replaced images
                
                // Get a list of the index (or indices) that changed
                NSIndexSet *indexSetOfChanges = change[NSKeyValueChangeIndexesKey];
                
                // Convert this NSIndexSet to an NSArray of NSIndexPaths (which is what the table view animation methods require)
                NSMutableArray *indexPathsThatChanged = [NSMutableArray array];
                [indexSetOfChanges enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
                    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:idx inSection:0];
                    [indexPathsThatChanged addObject:newIndexPath];
                }];
                
                // Call `beginUpdates` to tell the table view we're about to make changes
                
                NSLog(@"numberOfRowsInSection: %ld", (long)[self tableView:self numberOfRowsInSection:0]);
                
                NSLog(@"indexPathsThatChanged is: %@", indexPathsThatChanged);
                NSLog(@"indexPathsThatChanged is: %@", [BSDataSource sharedInstance].categoryItems);
                
                [self beginUpdates];
                
                NSLog(@"numberOfRowsInSection: %ld", (long)[self tableView:self numberOfRowsInSection:0]);

                // Tell the table view what the changes are
                if (kindOfChange == NSKeyValueChangeInsertion) {
                    [self insertRowsAtIndexPaths:indexPathsThatChanged withRowAnimation:UITableViewRowAnimationAutomatic];
                } else if (kindOfChange == NSKeyValueChangeRemoval) {
                    [self deleteRowsAtIndexPaths:indexPathsThatChanged withRowAnimation:UITableViewRowAnimationAutomatic];
                } else if (kindOfChange == NSKeyValueChangeReplacement) {
                    [self reloadRowsAtIndexPaths:indexPathsThatChanged withRowAnimation:UITableViewRowAnimationAutomatic];
                }
                
                NSLog(@"numberOfRowsInSection: %ld", (long)[self tableView:self numberOfRowsInSection:0]);
                NSLog(@"indexPathsThatChanged is: %@", indexPathsThatChanged);
                NSLog(@"indexPathsThatChanged is: %@", [BSDataSource sharedInstance].categoryItems);
                
                // Tell the table view that we're done telling it about changes, and to complete the animation
                
                [self endUpdates];
            }
    }
    
    NSLog(@"This method Did Run: observeValueForKeyPath");
}

#pragma Adding a row

- (void)add:(UIButton *)sender
{
    NSMutableArray *categoriesArray = [@[@""] mutableCopy];
    NSString *addCategoryPlaceHolderName = @"New Category";
    
    BSCategoryData *item = [[BSCategoryData alloc] initWithCategoryName:addCategoryPlaceHolderName categories:categoriesArray];
    
    [[BSDataSource sharedInstance] addCategoryItem:item];
    
//    [self reloadData];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"numberOfRowsChanged"
                                                            object:nil];
    });
    
    NSLog(@"indexPathsThatChanged is: %@", [BSDataSource sharedInstance].categoryItems);
    
    [self reloadData];
    
    NSLog(@"This Method was called: BSCategoryTableView add");
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    NSInteger index = self.replaceIndex.row;
    
    NSMutableArray *categoriesArray = [@[@""] mutableCopy];
    NSString *newCategoryName = textField.text;
    
    BSCategoryData *item = [[BSCategoryData alloc] initWithCategoryName:newCategoryName categories:categoriesArray];
    
    [[BSDataSource sharedInstance] replaceCategoryItem:item index:index];
    
    [self.textField removeFromSuperview];
    self.textField.text = nil;
    
    [self reloadData];
    
    NSLog(@"After replacing a cell CategoryItems is: %@", [BSDataSource sharedInstance].categoryItems);
    
    return NO;
}

@end
