//
//  BSSearchTableViewController.m
//  BlocSpot
//
//  Created by Philip Sopher on 8/21/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "BSSearchTableViewController.h"
#import "BSMapViewController.h"
#import "BSDataSource.h"


@interface BSSearchTableViewController ()

@property (nonatomic, strong) MKMapView *mapViewReference;
@property (nonatomic, assign) MKCoordinateRegion *mapRegionReference;

@property (nonatomic, strong) MKLocalSearch *localSearch;
@property (nonatomic, strong) MKLocalSearchRequest *localSearchRequest;
@property (nonatomic, strong) MKLocalSearchResponse *localSearchResponse;

@end

@implementation BSSearchTableViewController

- (instancetype) init {
    
    self = [super init];
    
    if (self) {
        
        self.mapViewReference = [[MKMapView alloc] init];
        self.localSearchResponse = [[MKLocalSearchResponse alloc] init];
        
        self.title = NSLocalizedString(@"Search", @"Search View");
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.mapViewReference = [BSDataSource sharedInstance].mapViewCurrent;
    self.mapRegionReference = [BSDataSource sharedInstance].mapViewCurrentRegion;
    
//    [self initializeTableContent];
    
    [self initializeSearchController];
    
    [self styleTableView];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Initialization methods

//- (void)initializeTableContent {
//    
//    //sections are defined here as a NSArray of string objects (i.e. letters representing each section)
//    self.tableSections = [[Item fetchDistinctItemGroupsInManagedObjectContext:self.managedObjectContext] mutableCopy];
//    
//    //sections and items are defined here as a NSArray of NSDictionaries whereby the key is a letter and the value is a NSArray of string opbjects of names
//    self.tableSectionsAndItems = [[Item fetchItemNamesByGroupInManagedObjectContext:self.managedObjectContext] mutableCopy];
//}

- (void)initializeSearchController {
    
    //instantiate a search results controller for presenting the search/filter results (will be presented on top of the parent table view)
    self.searchResultsController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:self.searchResultsController];
    
    //this ViewController will be responsible for implementing UISearchResultsDialog protocol method(s) - so handling what happens when user types into the search bar
    self.searchController.searchResultsUpdater = self;
    
    
    //this ViewController will be responsisble for implementing UISearchBarDelegate protocol methods(s)
    self.searchController.searchBar.delegate = self;
    
    self.searchResultsController.tableView.dataSource = self;
    
    self.searchResultsController.tableView.delegate = self;
    
    //this view controller can be covered by theUISearchController's view (i.e. search/filter table)
    self.definesPresentationContext = YES;
    
    
    //define the frame for the UISearchController's search bar and tint
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    
    self.searchController.searchBar.tintColor = [UIColor whiteColor];
    
    //add the UISearchController's search bar to the header of this table
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
}

- (void)styleTableView {
    
    [[self tableView] setSectionIndexColor:[UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1.0f]];
    
    [[self tableView] setSectionIndexBackgroundColor:[UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f]];
}

#pragma Search Methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    NSLog(@"This method ran: searchBarSearchButtonClicked");
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    // Cancel any previous searches.
    [self.localSearch cancel];
    
    NSLog(@"This method ran: searchBarTextDidBeginEditing");
    
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
    NSLog(@"This method ran: searchBarTextDidEndEditing");
    
}

#pragma mark - UITableViewDataSource methods

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    
//    return [self.tableSections count];
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"The number of rows in the search view should be %lu", (unsigned long)[self.localSearchResponse.mapItems count]);
    
    return [self.localSearchResponse.mapItems count];
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    
//    return [self.tableSections objectAtIndex:section];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *IDENTIFIER = @"SearchResultsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:IDENTIFIER];
    }
    
    MKMapItem *item = self.localSearchResponse.mapItems[indexPath.row];
    
    cell.textLabel.text = item.name;
    cell.detailTextLabel.text = item.placemark.addressDictionary[@"Street"];
    
    return cell;
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MKMapItem *item = self.localSearchResponse.mapItems[indexPath.row];
    [self.mapViewReference addAnnotation:item.placemark];
    [self.mapViewReference selectAnnotation:item.placemark animated:YES];
    
    [self.mapViewReference setCenterCoordinate:item.placemark.location.coordinate animated:YES];
    
    [self.mapViewReference setUserTrackingMode:MKUserTrackingModeNone];

    [BSDataSource sharedInstance].mapViewCurrent = self.mapViewReference;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"searchCreatedMapAnnotation"
                                                            object:nil];
    });
    
    [self.navigationController popToRootViewControllerAnimated:YES]; //takes you to root of navigation
    
}
//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    
//    //only show section index titles if there is no text in the search bar
//    if(!self.searchController.searchBar.text.length > 0) {
//        
//        NSArray *indexTitles = [Item fetchDistinctItemGroupsInManagedObjectContext:self.managedObjectContext];
//        
//        return indexTitles;
//        
//    } else {
//        
//        return nil;
//    }
//}

//- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
//{
//    //background color of section
//    view.tintColor = [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1.0f];
//    
//    //color of text in header
//    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
//    
//    [header.textLabel setTextColor:[UIColor whiteColor]];
//}

#pragma mark - UISearchResultsUpdating


- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    if (self.searchController.searchBar.text.length > 0) {
        // Perform a new search.
        self.localSearchRequest = [[MKLocalSearchRequest alloc] init];
        self.localSearchRequest.naturalLanguageQuery = self.searchController.searchBar.text;
        self.localSearchRequest.region = self.mapViewReference.region;
    
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        self.localSearch = [[MKLocalSearch alloc] initWithRequest:self.localSearchRequest];
    
        self.localSearchResponse = [[MKLocalSearchResponse alloc] init];
    

        [self.localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error){
        
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
            if (error != nil) {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Map Error",nil)
                                            message:[error localizedDescription]
                                           delegate:nil
                                  cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil] show];
                return;
            }
        
            if ([response.mapItems count] == 0) {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No Results",nil)
                                            message:nil
                                           delegate:nil
                                  cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil] show];
                return;
            }
        
            self.localSearchResponse = response;
        
            [self.searchResultsController.tableView reloadData];
        }];
    };
    
    NSLog(@"This method ran: updateSearchResultsForSearchController");
}

#pragma mark - UISearchBarDelegate methods

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
//    [self.tableSections removeAllObjects];
//    
//    [self.tableSectionsAndItems removeAllObjects];
//    
//    self.tableSections = [[Item fetchDistinctItemGroupsInManagedObjectContext:self.managedObjectContext] mutableCopy];
//    
//    self.tableSectionsAndItems = [[Item fetchItemNamesByGroupInManagedObjectContext:self.managedObjectContext] mutableCopy];
    
    NSLog(@"This method ran: searchBarCancelButtonClicked");
}

@end
