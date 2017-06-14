//
//  TransitionToDetailController.h
//  WeatherObjective
//
//  Created by Nathan Birkholz on 6/13/17.
//  Copyright © 2017 natebirkholz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransitionToDetailController : NSObject <UIViewControllerAnimatedTransitioning>

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext;
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext;

@end
