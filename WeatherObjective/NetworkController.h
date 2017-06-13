//
//  NetworkController.h
//  WeatherObjective
//
//  Created by Nathan Birkholz on 6/7/17.
//  Copyright © 2017 natebirkholz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationController.h"
#import "Enums.h"

@interface NetworkController : NSObject

@property (strong, nonatomic) LocationController *locationController;
@property (strong, nonatomic) NSString *urlForApi;

+(id)sharedController;

- (void)getArrayOfForecastsWithCompletionHandler:(void (^_Nonnull)(NSArray  * _Nullable forecasts, WeatherErrorType error))completionHandler;

@end
