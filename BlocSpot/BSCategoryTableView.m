//
//  BSCategoryTableViewController.m
//  BlocSpot
//
//  Created by Philip Sopher on 8/21/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "BSCategoryTableView.h"

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
        
        self.headerView = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0,0,self.bounds.size.width,40)];
        
    }
    
    return self;
}

- (void)viewDidLoad
{
//    [super viewDidLoad];
    
    [self registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:headerReuseIdentifier];
    
//    [[self navigationItem] setRightBarButtonItem:addButton];
//    [addButton release];
    

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
- (void)add
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
    
    CGFloat widthPadding = 40;
    
    self.headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(widthPadding, 2, self.frame.size.width - widthPadding - widthPadding, 20)];
    self.headerLabel.text = @"Choose Category";
    self.headerLabel.backgroundColor = [UIColor clearColor];
    self.headerLabel.textColor=[UIColor blackColor];
    self.headerLabel.font = [UIFont boldSystemFontOfSize:15];
    [self.headerView.contentView addSubview:self.headerLabel];
    
    //  Configure the Add button
//    self.addButton = [[UIButton alloc]
//                      initWithFrame:CGRectMake(self.headerLabel.frame.size.width + widthPadding, 0, widthPadding, self.headerLabel.frame.size.height)
//                      target:self
//                      action:@selector(add)];
    
    NSLog(@"This Method was called: BSCategoryTableView viewForHeaderInSection");
    
    return self.headerView;
}



- (CGFloat)tableView:(UITableView *)tableView tableViewHeightForHeaderInSection:(NSInteger)section {
    
    NSLog(@"This Method was called: BSCategoryTableView tableViewHeightForHeaderInSection");
    
    return 40.f;
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    
    NSLog(@"This Method was called: BSCategoryTableView numberOfSectionsInTableView");
    
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSLog(@"This Method was called: BSCategoryTableView numberOfRowsInSection");
    
    return 4;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"category"];
        
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"category"];
    }
    
    [cell.textLabel setText:@"apple"];
    
    NSLog(@"This Method was called: BSCategoryTableView cellForRowAtIndexPath");
    
    return cell;
}

@end
