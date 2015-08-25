//
//  BSCategoryTransitionAnimator.m
//  BlocSpot
//
//  Created by Philip Sopher on 8/23/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "BSCategoryTransitionAnimator.h"
#import "BSCategoryTableViewController.h"
#import "BSLocationsTableViewController.h"
#import "BSMapViewController.h"

@interface BSCategoryTransitionAnimator ()

@end

@implementation BSCategoryTransitionAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.2;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGFloat paddingWidth = 20;
    CGFloat paddingHeight = 60;
    CGFloat categoryEndWidth = fromViewController.view.frame.size.width - paddingWidth - paddingWidth;
    CGFloat categoryEndHeight = fromViewController.view.frame.size.height - paddingHeight - paddingHeight;
    
    
    CGRect categoryEndFrame = CGRectMake(paddingWidth, paddingHeight, categoryEndWidth, categoryEndHeight);
    
    if (self.presenting) {
        BSCategoryTableViewController *categoryVC = (BSCategoryTableViewController *)toViewController;
        
        fromViewController.view.userInteractionEnabled = NO;
        
        [transitionContext.containerView addSubview:toViewController.view];
        
        CGRect startFrame = [transitionContext.containerView convertRect:self.customCategoryView.bounds fromView:self.customCategoryView];
        CGRect endFrame = categoryEndFrame;
        
        toViewController.view.frame = startFrame;
        categoryVC.tableView.frame = toViewController.view.bounds;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
            
            categoryVC.tableView.frame = endFrame;
//            [categoryVC centerScrollView];
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
    else {
        BSCategoryTableViewController *categoryVC = (BSCategoryTableViewController *)fromViewController;
        
        CGRect endFrame = [transitionContext.containerView convertRect:self.customCategoryView.bounds fromView:self.customCategoryView];
        CGRect imageStartFrame = [categoryVC.tableView convertRect:categoryVC.tableView.frame fromView:categoryVC.tableView];
        CGRect imageEndFrame = [transitionContext.containerView convertRect:endFrame toView:categoryVC.tableView];
        
        imageEndFrame.origin.y = 0;
        
        [categoryVC.tableView addSubview:categoryVC.tableView];
        categoryVC.tableView.frame = imageStartFrame;
        categoryVC.tableView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
        
        toViewController.view.userInteractionEnabled = YES;
        
        [UITableView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            categoryVC.tableView.frame = endFrame;
            categoryVC.tableView.frame = imageEndFrame;
            
            toViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
}



@end
