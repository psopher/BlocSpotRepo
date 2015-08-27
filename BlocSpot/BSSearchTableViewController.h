//
//  BSSearchTableViewController.h
//  BlocSpot
//
//  Created by Philip Sopher on 8/21/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManager.h>
#import <AddressBook/AddressBook.h>

@interface BSSearchTableViewController : UITableViewController <UISearchResultsUpdating, UISearchBarDelegate, UISearchDisplayDelegate, UISearchBarDelegate, UISearchControllerDelegate>

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) UITableViewController *searchResultsController;

//@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
