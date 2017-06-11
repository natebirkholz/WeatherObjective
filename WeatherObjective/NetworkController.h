//
//  NetworkController.h
//  WeatherObjective
//
//  Created by Nathan Birkholz on 6/7/17.
//  Copyright © 2017 natebirkholz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationController.h"

@interface NetworkController : NSObject

@property (strong, nonatomic) LocationController *locationController;

+(id)sharedController;

@end
