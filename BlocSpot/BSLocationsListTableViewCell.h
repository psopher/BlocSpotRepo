//
//  BSLocationsListTableViewCell.h
//  BlocSpot
//
//  Created by Philip Sopher on 9/28/15.
//  Copyright © 2015 Bloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BSBlocSpotData;

@interface BSLocationsListTableViewCell : UITableViewCell

@property (nonatomic, strong) BSBlocSpotData *locationsItem;

@property (nonatomic, strong) UILabel *blocSpotName;
@property (nonatomic, strong) UILabel *blocSpotNotes;
@property (nonatomic, strong) UILabel *blocSpotDistance;
@property (nonatomic, strong) UIImageView *blocSpotCategory;

@end
