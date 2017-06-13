//
//  LocationController.h
//  WeatherObjective
//
//  Created by Nathan Birkholz on 6/8/17.
//  Copyright © 2017 natebirkholz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Enums.h"

@interface LocationController : NSObject <CLLocationManagerDelegate>

@property (strong, nonatomic) NSString *currentZipCode;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLGeocoder *geocoder;

- (void)updateLocationWithCompletionHandler:(void (^_Nonnull)(WeatherErrorType error))completionHandler;

@end
