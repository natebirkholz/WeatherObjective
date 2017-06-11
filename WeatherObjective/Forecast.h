//
//  Forecast.h
//  WeatherObjective
//
//  Created by Nathan Birkholz on 6/7/17.
//  Copyright © 2017 natebirkholz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Forecast : NSObject

@property (strong, nonatomic) NSString *day;
@property (strong, nonatomic) NSString *type;
@property NSInteger humidity;
@property NSInteger maxTemp;
@property NSInteger minTemp;

- (instancetype)initWithDay:(NSString *)day andForecastType:(NSString *)type andHumdity:(NSNumber *)humidity andMaxTemp:(NSNumber *)maxTemp andMinTemp:(NSNumber *)minTemp;

@end
