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

//@property (nonatomic, strong) MKMapView *mapViewReference;
@property (nonatomic, assign) MKCoordinateRegion *mapRegionReference;

@property (nonatomic, strong) MKLocalSearch *localSearch;
@property (nonatomic, strong) MKLocalSearchRequest *localSearchRequest;
@property (nonatomic, strong) MKLocalSearchResponse *localSearchResponse;

@end

@implementation BSSearchTableViewController

- (instancetype) init {
    
    self = [super init];
    
    if (self) {
        
        self.objectsInBSSectionName = [[[NSMutableArray alloc] init] mutableCopy];
        self.objectsInBSSectionAddress = [[[NSMutableArray alloc] init] mutableCopy];
        self.objectsInGRSectionName = [[[NSMutableArray alloc] init] mutableCopy];
        self.objectsInGRSectionAddress = [[[NSMutableArray alloc] init] mutableCopy];
        
//        self.mapViewReference = [[MKMapView alloc] init];
        self.localSearchResponse = [[MKLocalSearchResponse alloc] init];
        
        self.title = NSLocalizedString(@"Search", @"Search View");
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
//    self.mapViewReference = [BSDataSource sharedInstance].mapViewCurrent;
//    self.mapRegionReference = [BSDataSource sharedInstance].mapViewCurrentRegion;
    
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
    
    //Initialize section indexes array
    self.sectionTitles = [NSArray arrayWithObjects:@"BlocSpot",
                          @"Google Results", nil];
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.sectionTitles count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"The number of rows in the search view should be %lu", (unsigned long)[self.localSearchResponse.mapItems count]);
    
    if (section == 0) {
        
        NSLog(@"The number of rows in the BlocSpots Section should be %lu", (unsigned long)self.objectsInBSSectionName.count);
        
        return self.objectsInBSSectionName.count;
    } else {
        
        NSLog(@"The number of rows in the Google Results Section should be %lu", (unsigned long)self.objectsInGRSectionName.count);
        
        return self.localSearchResponse.mapItems.count - self.objectsInBSSectionName.count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [self.sectionTitles objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *IDENTIFIER = @"SearchResultsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:IDENTIFIER];
    }
    
    MKMapItem *item = self.localSearchResponse.mapItems[indexPath.row];
    
    if (self.objectsInBSSectionName.count > 0
        && [self.objectsInBSSectionName containsObject:item.name] && self.indexBS < self.objectsInBSSectionName.count
        ) {
        NSString *itemBSName = self.objectsInBSSectionName[self.indexBS];
        NSString *itemBSAddress = self.objectsInBSSectionAddress[self.indexBS];
        if (indexPath.section == 0) {
            cell.textLabel.text= itemBSName;
            cell.detailTextLabel.text= itemBSAddress;
            self.indexBS++;
        }
    }
    if (self.objectsInGRSectionName.count > 0
        && [self.objectsInGRSectionName containsObject:item.name] && self.indexGR < self.objectsInGRSectionName.count
        ) {
        NSString *itemGRName = self.objectsInGRSectionName[self.indexGR];
        NSString *itemGRAddress = self.objectsInGRSectionAddress[self.indexGR];
        if (indexPath.section == 1) {
            cell.textLabel.text= itemGRName;
            cell.detailTextLabel.text= itemGRAddress;
            self.indexGR++;
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MKMapItem *item = self.localSearchResponse.mapItems[indexPath.row];
    MKPointAnnotation* annotation = [[MKPointAnnotation alloc] init];
    annotation.title = item.placemark.name;
    annotation.coordinate = item.placemark.location.coordinate;
    
    BSMapViewController* mapVC = (BSMapViewController*)[self.navigationController viewControllers][0];
    
    
    [mapVC.mapView addAnnotation:annotation];
    [mapVC.mapView selectAnnotation:annotation animated:YES];
    
    [mapVC.mapView setCenterCoordinate:annotation.coordinate animated:YES];
    
    [mapVC.mapView setUserTrackingMode:MKUserTrackingModeNone];

//    [BSDataSource sharedInstance].mapViewCurrent = self.mapViewReference;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"searchCreatedMapAnnotation"
                                                            object:nil];
    });
    
    [self.navigationController popToRootViewControllerAnimated:YES]; //takes you to root of navigation
    
}


#pragma mark - UISearchResultsUpdating


- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    if (self.searchController.searchBar.text.length > 0) {
        
        BSMapViewController* mapVC = (BSMapViewController*)[self.navigationController viewControllers][0];
        // Perform a new search.
        self.localSearchRequest = [[MKLocalSearchRequest alloc] init];
        self.localSearchRequest.naturalLanguageQuery = self.searchController.searchBar.text;
        self.localSearchRequest.region = mapVC.mapView.region;
    
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
            
            [self.objectsInBSSectionName removeAllObjects];
            [self.objectsInBSSectionAddress removeAllObjects];
            [self.objectsInGRSectionName removeAllObjects];
            [self.objectsInGRSectionAddress removeAllObjects];
            
            NSArray *allKeys = [[BSDataSource sharedInstance].blocSpotDataMutableDictionary allKeys];
            
            for (NSInteger i = 0; i < self.localSearchResponse.mapItems.count; i++) {
                MKMapItem *item = self.localSearchResponse.mapItems[i];
                if ([allKeys containsObject:item.name]) {
                    [self.objectsInBSSectionName addObject:self.localSearchResponse.mapItems[i].name];
                    if (item.placemark.addressDictionary[@"Street"] != nil) {
                        [self.objectsInBSSectionAddress addObject:item.placemark.addressDictionary[@"Street"]];
                    } else {
                        [self.objectsInGRSectionAddress addObject:@"No Address Given"];
                    }
                } else {
                    [self.objectsInGRSectionName addObject:item.name];
                    if (item.placemark.addressDictionary[@"Street"] != nil) {
                        [self.objectsInGRSectionAddress addObject:item.placemark.addressDictionary[@"Street"]];
                    } else {
                        [self.objectsInGRSectionAddress addObject:@"No Address Given"];
                    }
                }
            }
        
            self.indexBS = 0;
            self.indexGR = 0;
            
            [self.searchResultsController.tableView reloadData];
        }];
    };
    
    NSLog(@"This method ran: updateSearchResultsForSearchController");
}

#pragma mark - UISearchBarDelegate methods

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    
    NSLog(@"This method ran: searchBarCancelButtonClicked");
}

@end
