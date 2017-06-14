//
//  TransitionToDetailController.m
//  WeatherObjective
//
//  Created by Nathan Birkholz on 6/13/17.
//  Copyright © 2017 natebirkholz. All rights reserved.
//

#import "TransitionToDetailController.h"
#import "ViewController.h"
#import "DetailViewController.h"
#import "WeatherCell.h"

@implementation TransitionToDetailController

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 1.0;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    ViewController *fromVc = (ViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    DetailViewController *toVc = (DetailViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];

    NSIndexPath *selectedIndexPath = [[fromVc tableView] indexPathForSelectedRow];
    WeatherCell *cell = (WeatherCell *)[[fromVc tableView] cellForRowAtIndexPath:selectedIndexPath];
    UIView *snapshotView = [[cell cellImageView] snapshotViewAfterScreenUpdates:NO];
    CGRect snapshotRect = [containerView convertRect:[[cell cellImageView] frame] fromView:[[fromVc tableView] cellForRowAtIndexPath:selectedIndexPath]];
    [snapshotView setFrame:snapshotRect];
    [[cell cellImageView] setHidden:YES];

    [[toVc view] setFrame:[transitionContext finalFrameForViewController:toVc]];
    [[toVc view] setAlpha:0.0];
    [[toVc imageView] setHidden:YES];
    [[toVc humidityLabel] setFrame:[[toVc humidityLabel] frame]];

    [containerView addSubview:[toVc view]];
    [containerView addSubview:snapshotView];

    [[toVc view] setNeedsLayout];
    [[toVc view] layoutIfNeeded];

    [UIView animateWithDuration:duration animations:^{
        [[toVc view] setAlpha:1.0];
        [snapshotView setFrame:[[toVc imageView] frame]];
    } completion:^(BOOL finished) {
        [[toVc imageView] setHidden:NO];
        [[cell cellImageView] setHidden:NO];
        [snapshotView removeFromSuperview];
        [transitionContext completeTransition:YES];
        [[fromVc tableView] deselectRowAtIndexPath:selectedIndexPath animated:NO];
    }];
}

@end
