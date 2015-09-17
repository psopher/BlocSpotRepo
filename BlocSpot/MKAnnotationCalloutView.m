//
//  MKAnnotationViewController.m
//  BlocSpot
//
//  Created by Philip Sopher on 9/15/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "MKAnnotationCalloutView.h"
#import "BSDataSource.h"

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
    
    [self addSubview:self.headerView];
    [self addSubview:self.textView];
    [self addSubview:self.buttonsView];
    
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
    
    [self.buttonsView addSubview:self.directionsButton];
    [self.buttonsView addSubview:self.shareButton];
    [self.buttonsView addSubview:self.trashButton];
    
}

-(void)subviewLayouts {
    
    //Header View
    CGFloat heartButtonStartX = (self.headerView.bounds.size.width/6)*5;
    CGFloat heartButtonWidth = self.headerView.bounds.size.width/6;
    CGFloat buttonPaddingY = 5;
    CGFloat heartButtonHeight= self.headerView.bounds.size.height - buttonPaddingY - buttonPaddingY;
    
    self.heartButton.frame = CGRectMake(heartButtonStartX, buttonPaddingY, heartButtonWidth, heartButtonHeight);
    
    CGFloat headerLabelStartX = buttonPaddingY;
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
    
//    if ([self.heartButton.imageView.image  isEqual: self.heartButtonImage]) {
//        UIImage *visitedButtonImage = [UIImage imageNamed:visitedImage];
//        [self.heartButton setImage:visitedButtonImage forState:UIControlStateNormal];
//    } else {
//        [self.heartButton setImage:self.heartButtonImage forState:UIControlStateNormal];
//    }
    
    if ([self.heartButton.imageView.image  isEqual: self.heartButtonImage]) {
        [self.heartButton setImage:self.visitedButtonImage forState:UIControlStateNormal];
    } else {
        [self.heartButton setImage:self.heartButtonImage forState:UIControlStateNormal];
    }
    
    NSLog(@"This method ran: heartButtonPressed");
}

- (void) commentButtonPressed:(UIBarButtonItem *)sender {
    
    if (self.isWritingComment) {
        [self.textView resignFirstResponder];
        self.textView.userInteractionEnabled = YES;
        [self.delegate textViewDidPressCommentButton:self];
    } else {
        [self setIsWritingComment:YES animated:YES];
        [self.textView becomeFirstResponder];
    }
    
    NSLog(@"This method ran: commentButtonPressed");
}

- (void) directionsButtonPressed:(UIBarButtonItem *)sender {
    
    NSLog(@"This method ran: directionsButtonPressed");
}

- (void) shareButtonPressed:(UIBarButtonItem *)sender {
    
    NSLog(@"This method ran: shareButtonPressed");
}

- (void) trashButtonPressed:(UIBarButtonItem *)sender {
    
    NSLog(@"This method ran: trashButtonPressed");
}

#pragma Makes the callout disappear when a different spot on the map is tapped

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
    UIView* hitView = [super hitTest:point withEvent:event];
    if (hitView != self && hitView != self.headerView && hitView != self.textView && hitView != self.buttonsView && hitView != self.heartButton && hitView != self.commentButton && hitView != self.directionsButton && hitView != self.shareButton && hitView != self.trashButton)
    {
        [self removeFromSuperview];
    }
    
    NSLog(@"This method ran: MKAnnotationCalloutView hitTest");
    
    return hitView;
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
