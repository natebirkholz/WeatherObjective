//
//  Forecast.m
//  WeatherObjective
//
//  Created by Nathan Birkholz on 6/7/17.
//  Copyright © 2017 natebirkholz. All rights reserved.
//

#import "Forecast.h"

@implementation Forecast

- (instancetype)initWithDay:(NSString *)day andForecastType:(NSString *)type andHumdity:(NSNumber *)humidity andMaxTemp:(NSNumber *)maxTemp andMinTemp:(NSNumber *)minTemp {
    self = [super init];
    if (self) {
        self.day = day;
        self.type = type;
        self.humidity = [humidity integerValue];
        self.maxTemp = [maxTemp integerValue];
        self.minTemp = [minTemp integerValue];
    }

    return self;
}

@end
