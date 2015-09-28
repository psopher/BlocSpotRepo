//
//  BSLocationsListTableViewCell.m
//  BlocSpot
//
//  Created by Philip Sopher on 9/28/15.
//  Copyright © 2015 Bloc. All rights reserved.
//

#import "BSLocationsListTableViewCell.h"
#import "BSBlocSpotData.h"
#import "BSDataSource.h"

#define heartImage @"heart"
#define visitedImage @"visited"

static UIFont *lightFont;
static UIFont *boldFont;
static UIColor *usernameLabelGray;
static UIColor *commentLabelGray;
static UIColor *linkColor;
static NSParagraphStyle *paragraphStyle;

@implementation BSLocationsListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.blocSpotCategory = [[UIImageView alloc] init];
        self.blocSpotDistance = [[UILabel alloc] init];
        self.blocSpotDistance.numberOfLines = 0;
        self.blocSpotName = [[UILabel alloc] init];
        self.blocSpotName.numberOfLines = 0;
        self.blocSpotNotes = [[UILabel alloc] init];
        self.blocSpotNotes.numberOfLines = 0;
        
        for (UIView *view in @[self.blocSpotCategory, self.blocSpotDistance, self.blocSpotName, self.blocSpotNotes]) {
            [self.contentView addSubview:view];
        }
    }
    return self;
}

+ (void)load {
    lightFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:11];
    boldFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:11];
    usernameLabelGray = [UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1]; /*#eeeeee*/
    commentLabelGray = [UIColor colorWithRed:0.898 green:0.898 blue:0.898 alpha:1]; /*#e5e5e5*/
    linkColor = [UIColor colorWithRed:0.345 green:0.314 blue:0.427 alpha:1]; /*#58506d*/
    
    NSMutableParagraphStyle *mutableParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    mutableParagraphStyle.headIndent = 20.0;
    mutableParagraphStyle.firstLineHeadIndent = 20.0;
    mutableParagraphStyle.tailIndent = -20.0;
    mutableParagraphStyle.paragraphSpacingBefore = 5;
    
    paragraphStyle = mutableParagraphStyle;
}

- (NSAttributedString *) blocSpotNameString {
    CGFloat usernameFontSize = 15;
    
    // Make a string that says "username caption text"
    NSString *baseString = [NSString stringWithFormat:@"%@", self.locationsItem.blocSpotName];
    
    // Make an attributed string, with the "username" bold
    NSMutableAttributedString *mutableblocSpotNameString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:@{NSFontAttributeName : [lightFont fontWithSize:usernameFontSize], NSParagraphStyleAttributeName : paragraphStyle}];
    
    NSRange blocSpotNameRange = [baseString rangeOfString:baseString];
    [mutableblocSpotNameString addAttribute:NSFontAttributeName value:[boldFont fontWithSize:usernameFontSize] range:blocSpotNameRange];
//    [mutableblocSpotNameString addAttribute:NSForegroundColorAttributeName value:linkColor range:blocSpotNameRange];
    
    
    NSLog(@"This method fired: BSLocationsTableViewCell blocSpotNameString");
    
    return mutableblocSpotNameString;
}

- (NSAttributedString *) blocSpotNotesString {
    
    NSString *baseString = [NSString stringWithFormat:@"%@", self.locationsItem.blocSpotNotes];
    
    NSMutableAttributedString *blocSpotNotesMutableString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:@{NSFontAttributeName : lightFont, NSParagraphStyleAttributeName : paragraphStyle}];
    
    NSLog(@"This method fired: BSLocationsTableViewCell blocSpotNotesString");
    
    return blocSpotNotesMutableString;
}

- (NSAttributedString *) blocSpotDistanceString {
    
//    NSString *baseString = [NSString stringWithFormat:@"%f", self.locationsItem.blocSpotNotes];
    
    NSString *baseString = @"0.1";
    
    NSMutableAttributedString *blocSpotMutableDistanceString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:@{NSFontAttributeName : lightFont, NSParagraphStyleAttributeName : paragraphStyle}];
    
    NSLog(@"This method fired: BSLocationsTableViewCell blocSpotDistanceString");
    
    return blocSpotMutableDistanceString;
}

- (UIImage *) blocSpotCategoryImage {
    if (self.locationsItem.blocSpotVisited == YES) {
        NSLog(@"This method fired: BSLocationsTableViewCell blocSpotCategoryImage");
        return [UIImage imageNamed:visitedImage];
    } else {
        NSLog(@"This method fired: BSLocationsTableViewCell blocSpotCategoryImage");
        return [UIImage imageNamed:heartImage];
    }
}

- (CGSize) sizeOfString:(NSAttributedString *)string {
    CGSize maxSize = CGSizeMake(CGRectGetWidth(self.contentView.bounds) - 40, 0.0);
    CGRect sizeRect = [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    sizeRect.size.height += 20;
    sizeRect = CGRectIntegral(sizeRect);
    
    NSLog(@"This method fired: BSLocationsTableViewCell sizeOfString");
    return sizeRect.size;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    CGFloat padding = 5;
    CGFloat heartSquareDimension = CGRectGetHeight(self.contentView.bounds)/3;
    self.blocSpotCategory.frame = CGRectMake(padding+padding, padding+padding, heartSquareDimension, heartSquareDimension);
    
    CGSize sizeOfBlocSpotNameLabel = [self sizeOfString:self.blocSpotName.attributedText];
    CGFloat labelStart = CGRectGetMaxX(self.blocSpotCategory.frame) + padding;
    CGFloat labelWidth = CGRectGetWidth(self.contentView.bounds) - labelStart - padding;
    self.blocSpotName.frame = CGRectMake(labelStart, padding, labelWidth, sizeOfBlocSpotNameLabel.height);
    
    CGSize sizeOfBlocSpotNotesLabel = [self sizeOfString:self.blocSpotNotes.attributedText];
    CGFloat blocSpotNotesYOrigin = CGRectGetMaxY(self.blocSpotName.frame) + padding;
    self.blocSpotNotes.frame = CGRectMake(labelStart, blocSpotNotesYOrigin, labelWidth, sizeOfBlocSpotNotesLabel.height);
    
    CGSize sizeOfBlocSpotDistanceLabel = [self sizeOfString:self.blocSpotDistance.attributedText];
    CGFloat blocSpotDistanceYOrigin = CGRectGetMaxY(self.blocSpotCategory.frame) + padding;
    self.blocSpotDistance.frame = CGRectMake(padding, blocSpotDistanceYOrigin, heartSquareDimension, sizeOfBlocSpotDistanceLabel.height);
    
    NSLog(@"This method fired: BSLocationsTableViewCell layoutSubviews");
}

- (void) setLocationsItem:(BSBlocSpotData *)locationsItem {
    _locationsItem = locationsItem;
    self.blocSpotName.attributedText = [self blocSpotNameString];
    self.blocSpotNotes.attributedText = [self blocSpotNotesString];
    self.blocSpotDistance.attributedText = [self blocSpotDistanceString];
    self.blocSpotCategory.image = [self blocSpotCategoryImage];
    
    NSLog(@"This method fired: BSLocationsTableViewCell setLocationItem");
}

@end
