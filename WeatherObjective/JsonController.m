//
//  JsonController.m
//  WeatherObjective
//
//  Created by Nathan Birkholz on 6/7/17.
//  Copyright © 2017 natebirkholz. All rights reserved.
//

#import "JsonController.h"
#import "Forecast.h"

@implementation JsonController

- (instancetype)init {
    if (self = [super init]) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [[self dateFormatter] setDateFormat:@"EEEE"];
    }

    return self;
}

- (NSArray *)parseForecastsFromJsonData:(NSData *)rawJsonData {

    NSError *error;
    NSMutableArray *arrayOfForecasts = [[NSMutableArray alloc] init];
    NSDictionary *dictionaryFromJson = [NSJSONSerialization JSONObjectWithData:rawJsonData options:NSJSONReadingAllowFragments error:&error];
    if (error) {
        NSLog(@"Error parsing JSON: %@", [error localizedDescription]);
        return [[NSArray alloc] init];
    }

    for (NSDictionary *jsonDictionary in dictionaryFromJson[@"list"]) {
        NSArray *weatherArray = jsonDictionary[@"weather"];
        NSDictionary *weatherDictionary = [weatherArray firstObject];
        NSInteger weatherId = [weatherDictionary[@"id"] integerValue];
        NSString *weatherType = [self getWeatherTypeFromWeatherId:weatherId];
        NSNumber *humidity = jsonDictionary[@"humidity"];
        NSDictionary *temperatureDictionary = jsonDictionary[@"temp"];
        NSNumber *maxTemp = temperatureDictionary[@"max"];
        NSNumber *minTemp = temperatureDictionary[@"min"];
        NSNumber *forecastDateCode = jsonDictionary[@"dt"];
        NSString *dayString = [self parseDateCodeIntoDay:forecastDateCode];

        Forecast *newForecast = [[Forecast alloc] initWithDay:dayString andForecastType:weatherType andHumdity:humidity andMaxTemp:maxTemp andMinTemp:minTemp];
        [arrayOfForecasts addObject:newForecast];
    }

    return arrayOfForecasts;
}

- (NSString *)getWeatherTypeFromWeatherId:(NSInteger)weatherId {
    if (weatherId == 800 || weatherId == 801) {
        return @"Sunny";
    } else if (weatherId >= 700 && weatherId <= 762) {
        return @"Cloudy";
    } else if (weatherId >= 802 && weatherId <= 804) {
        return @"Cloudy";
    } else if (weatherId >= 200 && weatherId <= 622) {
        return @"Rainy";
    } else if (weatherId == 771 || weatherId == 781 || weatherId == 905 || weatherId == 906) {
        return @"Rainy";
    } else if (weatherId >= 900 && weatherId <= 902) {
        return @"Rainy";
    } else {
        return @"Sunny";
    }
}

- (NSString *)parseDateCodeIntoDay:(NSNumber *)dateCode {
    NSTimeInterval interval = [dateCode doubleValue];
    NSDate *aDate = [NSDate dateWithTimeIntervalSince1970:interval];
    NSString *dateString = [[self dateFormatter] stringFromDate:aDate];
    return dateString;
}



@end
