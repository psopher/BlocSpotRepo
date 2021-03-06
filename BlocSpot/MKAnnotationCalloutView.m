//
//  MKAnnotationViewController.m
//  BlocSpot
//
//  Created by Philip Sopher on 9/15/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "MKAnnotationCalloutView.h"
#import "BSDataSource.h"
#import "BSSelectCategoryTableView.h"
#import "BSBlocSpotData.h"

#define directionsImage @"directions"
#define shareImage @"share"
#define trashImage @"trash"
#define heartImage @"heart"
#define visitedImage @"visited"

@implementation MKAnnotationCalloutView


- (id)initWithFrame:(CGRect)frame
{
    // First, call the superclass (UIView)'s initializer, to make sure we do all that setup first.
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        
        [self initializingViews];
        
        [self initializingSubviews];
        
    }

    return self;
}

- (void) layoutSubviews {
    
    [super layoutSubviews];
    
    [self viewLayouts];
    
    [self subviewLayouts];
    
}

#pragma Creating Buttons and Views

-(void)initializingViews {
    
    self.headerView = [[UIView alloc] init];
    self.headerView.backgroundColor = [UIColor whiteColor];
    self.textView = [[UITextView alloc] init];
    self.textView.delegate = self;
    self.textView.backgroundColor = [UIColor whiteColor];
    self.buttonsView = [[UIView alloc] init];
    self.buttonsView.backgroundColor = [UIColor whiteColor];
    
    self.selectCategoryTableView = [[BSSelectCategoryTableView alloc] init];
    
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    
    [self addSubview:self.headerView];
    [self addSubview:self.textView];
    [self addSubview:self.buttonsView];
    [self addSubview:self.selectCategoryTableView];
    
}

-(void)viewLayouts {
    
    CGFloat widthPadding = 5;
    CGFloat heightPadding = 5;
    CGFloat viewWidth = self.bounds.size.width - widthPadding - widthPadding;
    CGFloat headerHeight = self.bounds.size.height/5;
    CGFloat headerTextPadding = heightPadding*2;
    CGFloat textViewHeight = ((headerHeight-heightPadding)*3) - heightPadding;
    
    self.headerView.frame = CGRectMake(widthPadding, heightPadding, viewWidth, headerHeight);
    self.textView.frame = CGRectMake(widthPadding, self.headerView.frame.size.height + headerTextPadding, viewWidth, textViewHeight);
    self.buttonsView.frame = CGRectMake(widthPadding, headerHeight*4 - heightPadding, viewWidth, headerHeight);
    
}

-(void)initializingSubviews {
    
    //Header View
    self.heartButton = [[UIButton alloc] init];
    self.heartButtonImage = [UIImage imageNamed:heartImage];
    self.visitedButtonImage = [UIImage imageNamed:visitedImage];
    [self.heartButton setImage:self.heartButtonImage forState:UIControlStateNormal];
    [self.heartButton addTarget:self action:@selector(heartButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.headerLabel = [[UILabel alloc] init];
    
    [self.headerView addSubview:self.heartButton];
    [self.headerView addSubview:self.headerLabel];
    
    //Text View
    self.commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.commentButton setAttributedTitle:[self commentAttributedString] forState:UIControlStateNormal];
    [self.commentButton addTarget:self action:@selector(commentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.textView addSubview:self.commentButton];
    
    //Buttons View
    self.selectCategoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectCategoryButton.backgroundColor = [BSDataSource sharedInstance].colors[[BSDataSource sharedInstance].selectedCategoryIndex];
    NSString *baseString = [NSString stringWithFormat:@"%@", [BSDataSource sharedInstance].categoryItems[[BSDataSource sharedInstance].selectedCategoryIndex]];
    NSRange range = [baseString rangeOfString:baseString];
    NSMutableAttributedString *selectCategoryString = [[NSMutableAttributedString alloc] initWithString:baseString];
    [selectCategoryString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:11] range:range];
    [selectCategoryString addAttribute:NSKernAttributeName value:@1.3 range:range];
    [self.selectCategoryButton setAttributedTitle:selectCategoryString forState:UIControlStateNormal];
    [self.selectCategoryButton addTarget:self action:@selector(selectCategoryButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.directionsButton = [[UIButton alloc] init];
    UIImage *directionsButtonImage = [UIImage imageNamed:directionsImage];
    [self.directionsButton setImage:directionsButtonImage forState:UIControlStateNormal];
    [self.directionsButton addTarget:self action:@selector(directionsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.shareButton = [[UIButton alloc] init];
    UIImage *shareButtonImage = [UIImage imageNamed:shareImage];
    [self.shareButton setImage:shareButtonImage forState:UIControlStateNormal];
    [self.shareButton addTarget:self action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.trashButton = [[UIButton alloc] init];
    UIImage *trashButtonImage = [UIImage imageNamed:trashImage];
    [self.trashButton setImage:trashButtonImage forState:UIControlStateNormal];
    [self.trashButton addTarget:self action:@selector(trashButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.buttonsView addSubview:self.selectCategoryButton];
    [self.buttonsView addSubview:self.directionsButton];
    [self.buttonsView addSubview:self.shareButton];
    [self.buttonsView addSubview:self.trashButton];
    
}

-(void)subviewLayouts {
    
    //Header View
    CGFloat heartButtonStartX = (self.headerView.bounds.size.width/6)*5;
    CGFloat heartButtonWidth = self.headerView.bounds.size.width/6;
    CGFloat buttonPaddingX = 5;
    CGFloat buttonPaddingY = 5;
    CGFloat heartButtonHeight= self.headerView.bounds.size.height - buttonPaddingY - buttonPaddingY;
    
    self.heartButton.frame = CGRectMake(heartButtonStartX, buttonPaddingY, heartButtonWidth, heartButtonHeight);
    
    CGFloat headerLabelStartX = buttonPaddingX;
    CGFloat headerLabelStartY = buttonPaddingY;
    CGFloat headerLabelWidth = (self.headerView.bounds.size.width/6)*5 - buttonPaddingY;
    CGFloat headerLabelHeight = self.headerView.bounds.size.height - buttonPaddingY - buttonPaddingY;
    
    self.headerLabel.frame = CGRectMake(headerLabelStartX, headerLabelStartY, headerLabelWidth, headerLabelHeight);
    

    //Text View
    if (self.isWritingComment) {
        self.textView.backgroundColor = [UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1]; /*#eeeeee*/
        self.commentButton.backgroundColor = [UIColor colorWithRed:0.345 green:0.318 blue:0.424 alpha:1]; /*#58516c*/
        
        CGFloat buttonX = CGRectGetWidth(self.textView.bounds) - 100;
        self.commentButton.frame = CGRectMake(buttonX, self.textView.bounds.size.height - 30, 80, 20);
    } else {
        self.textView.backgroundColor = [UIColor colorWithRed:0.898 green:0.898 blue:0.898 alpha:1]; /*#e5e5e5*/
        self.commentButton.backgroundColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1]; /*#999999*/
    }
    
    CGSize buttonSize = self.commentButton.frame.size;
    buttonSize.height += 20;
    buttonSize.width += 20;
    CGFloat blockX = CGRectGetWidth(self.textView.bounds) - buttonSize.width;
    CGRect areaToBlockText = CGRectMake(blockX, 0, buttonSize.width, buttonSize.height);
    UIBezierPath *buttonPath = [UIBezierPath bezierPathWithRect:areaToBlockText];
    
    self.textView.textContainer.exclusionPaths = @[buttonPath];
    
    //Buttons View
    
    CGFloat selectCategoryButtonStartX = buttonPaddingX;
    CGFloat selectCategoryButtonStartY = buttonPaddingY;
    CGFloat selectCategoryButtonWidth = (self.buttonsView.bounds.size.width/6)*3;
    CGFloat selectCategoryButtonHeight = self.buttonsView.bounds.size.height - buttonPaddingY - buttonPaddingY;
    
    self.selectCategoryButton.frame =  CGRectMake(selectCategoryButtonStartX, selectCategoryButtonStartY, selectCategoryButtonWidth, selectCategoryButtonHeight);
    
    CGFloat directionsButtonStartX = self.buttonsView.bounds.size.width/2;
    CGFloat buttonWidth = self.buttonsView.bounds.size.width/6;
    CGFloat buttonHeight= self.buttonsView.bounds.size.height - buttonPaddingY - buttonPaddingY;
    CGFloat shareButtonStartX = directionsButtonStartX + buttonWidth;
    CGFloat trashButtonStartX = shareButtonStartX + buttonWidth;
    
    self.directionsButton.frame = CGRectMake(directionsButtonStartX, buttonPaddingY, buttonWidth, buttonHeight);
    self.shareButton.frame = CGRectMake(shareButtonStartX, buttonPaddingY, buttonWidth, buttonHeight);
    self.trashButton.frame = CGRectMake(trashButtonStartX, buttonPaddingY, buttonWidth, buttonHeight);
    
}

#pragma Buttons Pressed

- (void) heartButtonPressed:(UIBarButtonItem *)sender {
    
    if ([self.heartButton.imageView.image  isEqual: self.heartButtonImage]) {
        [self.heartButton setImage:self.visitedButtonImage forState:UIControlStateNormal];
        self.POI.visited = YES;
        [BSDataSource sharedInstance].blocSpotDataMutableDictionary[self.headerLabel.text] = self.POI;
    } else {
        [self.heartButton setImage:self.heartButtonImage forState:UIControlStateNormal];
        self.POI.visited = NO;
        [BSDataSource sharedInstance].blocSpotDataMutableDictionary[self.headerLabel.text] = self.POI;
    }
    
    NSMutableArray *blocSpotsMutableArray = [[NSMutableArray alloc] initWithArray:[[BSDataSource sharedInstance].blocSpotDataMutableDictionary allValues]];
    [BSDataSource sharedInstance].blocSpotDataMutableArray = blocSpotsMutableArray;
    
    [[BSDataSource sharedInstance] saveToDisk];
    
    NSLog(@"This method ran: heartButtonPressed");
}

- (void) commentButtonPressed:(UIBarButtonItem *)sender {
    
    if (self.isWritingComment) {
        [self.textView resignFirstResponder];
        self.commentButton.frame = CGRectMake(CGRectGetWidth(self.textView.bounds) - 100, self.textView.bounds.size.height - 30, 0, 0);
        self.textView.userInteractionEnabled = YES;
        [self.delegate textViewDidPressCommentButton:self];
    } else {
        [self setIsWritingComment:YES animated:YES];
        [self.textView becomeFirstResponder];
    }
    
    self.POI.notes = self.textView.text;
    [BSDataSource sharedInstance].blocSpotDataMutableDictionary[self.headerLabel.text] = self.POI;
    
    NSMutableArray *blocSpotsMutableArray = [[NSMutableArray alloc] initWithArray:[[BSDataSource sharedInstance].blocSpotDataMutableDictionary allValues]];
    [BSDataSource sharedInstance].blocSpotDataMutableArray = blocSpotsMutableArray;
    
    [[BSDataSource sharedInstance] saveToDisk];
    
    NSLog(@"This method ran: commentButtonPressed");
}

- (void) selectCategoryButtonPressed:(UIBarButtonItem *)sender {
    
    
    CGFloat selectCategoryTVWidth = (self.buttonsView.bounds.size.width/6)*3;
    CGFloat selectCategoryTVHeight = MIN((self.buttonsView.bounds.size.height - 10)*[[BSDataSource sharedInstance].categoryItems count], (self.buttonsView.bounds.size.height - 10)*5);
    [BSDataSource sharedInstance].selectCategoryCellHeight = self.selectCategoryButton.bounds.size.height;
    CGFloat selectCategoryTVStartX = CGRectGetMinX(self.buttonsView.frame) + 5;
    CGFloat selectCategoryTVStartY = CGRectGetMaxY(self.buttonsView.frame) - 5 - (selectCategoryTVHeight);
    
    self.selectCategoryTableView.frame = CGRectMake(selectCategoryTVStartX, selectCategoryTVStartY, selectCategoryTVWidth, selectCategoryTVHeight);
    
    NSLog(@"This method ran: selectCategoryButtonPressed");
}

- (void) directionsButtonPressed:(UIBarButtonItem *)sender {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"directionsFromUserLocation"
                                                            object:nil];
    });
    
    [self removeFromSuperview];
    
    NSLog(@"This method ran: directionsButtonPressed");
}

- (void) shareButtonPressed:(UIBarButtonItem *)sender {
    
    NSLog(@"This method ran: shareButtonPressed");
}

- (void) trashButtonPressed:(UIBarButtonItem *)sender {
    
    [[BSDataSource sharedInstance].blocSpotDataMutableDictionary removeObjectForKey:self.headerLabel.text];
    
    NSMutableArray *blocSpotsMutableArray = [[NSMutableArray alloc] initWithArray:[[BSDataSource sharedInstance].blocSpotDataMutableDictionary allValues]];
    [BSDataSource sharedInstance].blocSpotDataMutableArray = blocSpotsMutableArray;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"removeAnnotation"
                                                            object:nil];
    });
    
    [self removeFromSuperview];
    
    [[BSDataSource sharedInstance] saveToDisk];
    
    NSLog(@"This method ran: trashButtonPressed");
}

#pragma Makes the callout disappear when a different spot on the map is tapped

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
    UIView* hitView = [super hitTest:point withEvent:event];
    
    NSLog(@"hitView at point X: %f Y: %f", point.x, point.y);
    
    NSLog(@"TableView was selected and its frame is start X: %f start Y: %f width: %f height: %f", CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), self.bounds.size.width, self.bounds.size.height);
    
    if (point.x > self.bounds.size.width || point.x < 0 || point.y > self.bounds.size.height || point.y < 0){
        [self removeFromSuperview];
    }
    
    if (hitView != self.textView && hitView != self.commentButton) {
        [self.textView resignFirstResponder];
        self.commentButton.frame = CGRectMake(CGRectGetWidth(self.textView.bounds) - 100, self.textView.bounds.size.height - 30, 0, 0);
        self.textView.userInteractionEnabled = YES;
        [self.delegate textViewDidPressCommentButton:self];
    }
    if ([self point:point outsideViewsFrame:self.selectCategoryTableView] && [self point:point outsideViewsFrame:self.selectCategoryButton]){
        self.selectCategoryTableView.frame = CGRectMake(0, 0, 0, 0);
    }
    
    NSLog(@"TableView was selected and its frame is start X: %f start Y: %f width: %f height: %f", CGRectGetMinX(self.selectCategoryTableView.frame), CGRectGetMinY(self.selectCategoryTableView.frame), self.selectCategoryTableView.bounds.size.width, self.selectCategoryTableView.bounds.size.height);
    
    NSLog(@"This method ran: MKAnnotationCalloutView hitTest");
    
    return hitView;
}

- (BOOL) point: (CGPoint) point outsideViewsFrame: (UIView*) view{
    return point.x > CGRectGetMaxX(view.frame) || point.x < CGRectGetMinX(view.frame) || point.y > CGRectGetMaxY(view.frame) || point.y < CGRectGetMinY(view.frame);
}

#pragma Textfield and Textfield Delegate Methods

- (NSAttributedString *) commentAttributedString {
    NSString *baseString = NSLocalizedString(@"Done", @"comment button text");
    NSRange range = [baseString rangeOfString:baseString];
    
    NSMutableAttributedString *commentString = [[NSMutableAttributedString alloc] initWithString:baseString];
    
    [commentString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:10] range:range];
    [commentString addAttribute:NSKernAttributeName value:@1.3 range:range];
    [commentString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1] range:range];
    
    return commentString;
}

- (void) stopComposingComment {
    [self.textView resignFirstResponder];
}

- (void) setIsWritingComment:(BOOL)isWritingComment {
    [self setIsWritingComment:isWritingComment animated:NO];
}

- (void) setIsWritingComment:(BOOL)isWritingComment animated:(BOOL)animated {
    _isWritingComment = isWritingComment;
    
    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            [self layoutSubviews];
        }];
    } else {
        [self layoutSubviews];
    }
}

- (void) setText:(NSString *)text {
    _text = text;
    self.textView.text = text;
    self.textView.userInteractionEnabled = YES;
    self.isWritingComment = text.length > 0;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [self setIsWritingComment:YES animated:NO];
    [self.delegate commentViewWillStartEditing:self];
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *newText = [textView.text stringByReplacingCharactersInRange:range withString:text];
    [self.delegate textView:self textDidChange:newText];
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    BOOL hasComment = (textView.text.length > 0);
    [self setIsWritingComment:hasComment animated:YES];
    
    return YES;
}

@end
