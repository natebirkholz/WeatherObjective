//
//  JsonController.h
//  WeatherObjective
//
//  Created by Nathan Birkholz on 6/7/17.
//  Copyright © 2017 natebirkholz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonController : NSObject

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

- (NSArray *)parseForecastsFromJsonData:(NSData *)rawJsonData ;

@end
