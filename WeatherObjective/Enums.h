//
//  Enums.h
//  WeatherObjective
//
//  Created by Nathan Birkholz on 6/10/17.
//  Copyright © 2017 natebirkholz. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WeatherErrorType) {
    WeatherErrorNoError,
    WeatherErrorLocationError,
    WeatherErrorNetworkError,
    WeatherErrorParseError,
    WeatherErrorMissingInstance,
    WeatherErrorUnkown
};
