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

@end

@implementation BSCategoryTableView

@synthesize displayedObjects = _displayedObjects;

static NSString *headerReuseIdentifier = @"TableViewSectionHeaderViewIdentifier";

- (instancetype) init {
    
    self = [super init];
    
    if (self) {
        
        self.dataSource = self;
        self.delegate = self;
        
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

#pragma mark -
#pragma Adding a row

//  Creates a new nav controller with an instance of MyDetailController as
//  its root view controller, and runs it as a modal view controller. By
//  default, that causes the detail view to be animated as sliding up from
//  the bottom of the screen. And because the detail controller is the root
//  view controller, there's no back button.
//

//- (void)dealloc
//{
//    [_displayedObjects release];
//    
//    [super dealloc];
//}
//
////  Lazily initializes array of displayed objects
////
//- (NSMutableArray *)displayedObjects
//{
//    if (_displayedObjects == nil)
//    {
//        _displayedObjects = [[NSMutableArray alloc] initWithObjects:
//                             [Book bookWithTitle:@"Middlemarch"
//                                          author:@"Eliot, George"
//                                            year:1874
//                                   imageFilePath:@"Eliot.jpg"],
//                             [Book bookWithTitle:@"War and Peace"
//                                          author:@"Tolstoy, Leo"
//                                            year:1869
//                                   imageFilePath:@"Tolstoy.jpg"],
//                             [Book bookWithTitle:@"Mansfield Park"
//                                          author:@"Austen, Jane"
//                                            year:1814
//                                   imageFilePath:@"Austen.jpg"],
//                             [Book bookWithTitle:@"The New Atlantis"
//                                          author:@"Bacon, Francis"
//                                            year:1627
//                                   imageFilePath:@"Bacon.jpg"],
//                             [Book bookWithTitle:@"The Old Man and the Sea"
//                                          author:@"Hemingway, Ernest"
//                                            year:1952
//                                   imageFilePath:@"Hemingway.jpg"],
//                             nil];
//    }
//    
//    return _displayedObjects;
//}
//
//- (void)addObject:(id)anObject
//{
//    if (anObject != nil)
//    {
//        [[self displayedObjects] addObject:anObject];
//    }
//}
//
- (void)add:(UIButton *)sender
{
//    MyDetailController *controller = [[MyDetailController alloc]
//                                      initWithStyle:UITableViewStyleGrouped];
//    
//    id book = [[Book alloc] init];
//    [controller setBook:book];
//    [controller setListController:self];
//    
//    UINavigationController *newNavController = [[UINavigationController alloc]
//                                                initWithRootViewController:controller];
//    
//    [[self navigationController] presentModalViewController:newNavController
//                                                   animated:YES];
//    
//    [book release];
//    [controller release];
    
    NSLog(@"This Method was called: BSCategoryTableView add");
}


//- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
//    [super setEditing:editing animated:animated];
//    [self.tableView setEditing:editing animated:animated]; // not needed if super is a UITableViewController
//    
//    NSMutableArray* paths = [[NSMutableArray alloc] init];
//    
//    // fill paths of insertion rows here
//    
//    if( editing )
//        [self.tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationBottom];
//    else
//        [self.tableView deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationBottom];
//    
//    [paths release];
//}

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
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"categoryCell"];
        
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"categoryCell"];
    }
    
    [cell.textLabel setText:[BSDataSource sharedInstance].categoryItems[indexPath.row]];

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
    
    cellCheck.selectionStyle = UITableViewCellSelectionStyleNone;
}

#pragma Swipe to Delete Methods

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"The number of items in commitEditingStyle is: %lu", (unsigned long)[BSDataSource sharedInstance].categoryItems.count);
    NSLog(@"numberOfRowsInSection: %ld", (long)[self tableView:self numberOfRowsInSection:0]);
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        BSCategoryData *item = [BSDataSource sharedInstance].categoryItems[indexPath.row];
        [[BSDataSource sharedInstance] deleteMediaItem:item];
        
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

@end
