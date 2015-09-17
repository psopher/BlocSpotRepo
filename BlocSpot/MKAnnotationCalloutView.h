//
//  MKAnnotationViewController.h
//  BlocSpot
//
//  Created by Philip Sopher on 9/15/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>

@class MKAnnotationCalloutView;

@protocol MKAnnotationCalloutViewDelegate <NSObject>

- (void) textViewDidPressCommentButton:(MKAnnotationCalloutView *)sender;
- (void) textView:(MKAnnotationCalloutView *)sender textDidChange:(NSString *)text;
- (void) commentViewWillStartEditing:(MKAnnotationCalloutView *)sender;

@end

@interface MKAnnotationCalloutView : UIView <UITextViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) MKPlacemark* annotation;

@property (nonatomic, strong) UIView* headerView;
@property (nonatomic, strong) UITextView* textView;
@property (nonatomic, strong) UIView* buttonsView;

@property (nonatomic, strong) UIButton* heartButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIButton* directionsButton;
@property (nonatomic, strong) UIButton* shareButton;
@property (nonatomic, strong) UIButton* trashButton;

@property (nonatomic, strong) UIImage* heartButtonImage;
@property (nonatomic, strong) UIImage* visitedButtonImage;

@property (nonatomic, weak) NSObject <MKAnnotationCalloutViewDelegate> *delegate;
@property (nonatomic, assign) BOOL isWritingComment;
@property (nonatomic, strong) NSString *text;

- (void) stopComposingComment;

@end
