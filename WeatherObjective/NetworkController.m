//
//  NetworkController.m
//  WeatherObjective
//
//  Created by Nathan Birkholz on 6/7/17.
//  Copyright © 2017 natebirkholz. All rights reserved.
//

#import "NetworkController.h"
#import "Forecast.h"
#import "JsonController.h"

@interface NetworkController ()

@property (strong, nonatomic) JsonController *jsonController;

@end

@implementation NetworkController


// ------------------------
#pragma mark Singleton
// ------------------------

// Boilerplate standardized Singleton pattern as recommended by Apple

+ (id)sharedController {
    static NetworkController *sharedController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedController = [[self alloc] init];
    });
    return sharedController;
}

- (void)dealloc {
    // Recommended by Singleton pattern
}

- (instancetype) init {
    if (self = [super init]) {
        self.jsonController = [[JsonController alloc] init];
        self.locationController = [[LocationController alloc] init];
    }

    return self;
}

- (void)getArrayOfForecastsWithCompletionHandler:(void (^)(NSArray  * _Nullable forecasts, WeatherErrorType error))completionHandler {
    NSMutableString *locationString = [[NSMutableString alloc] init];
    NSString *zipCode = [[self locationController] currentZipCode];
    if (!zipCode) {
        [locationString setString:@"92102"];
    } else {
        [locationString setString:zipCode];
    }

    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?zip=%@,us&units=imperial&cnt=7&APPID=3e15652a662d33a186fdcf5567cf1f66", locationString];
    NSURL *apiUrl = [[NSURL alloc] initWithString: urlString];


    [self fetchJSONDataFromURL:apiUrl withCompletionHandler:^(NSData *dataFromURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!dataFromURL) {
                completionHandler(nil, WeatherErrorNetworkError);
                return;
            } else {
                NSArray *forecasts = [[self jsonController] parseForecastsFromJsonData: dataFromURL];
                if ([forecasts count] > 0) {
                    completionHandler(forecasts, WeatherErrorNoError);
                    return;
                } else {
                    completionHandler(nil, WeatherErrorParseError);
                    return;
                }
            }
        });
    }];


}

- (void)fetchJSONDataFromURL:(NSURL *)fetchURL withCompletionHandler:(void (^)(NSData *dataFromURL))completionHandler {
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:fetchURL];
    [request setHTTPMethod:@"GET"];

    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"HANDLE ERROR");
            completionHandler(nil);
        }

        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSInteger statusCode = [httpResponse statusCode];
        switch (statusCode) {
            case 200: {
                completionHandler(data);
                break;
            }
            default: {
                NSLog(@"Fell through");
                NSLog(@"Status code is %li", (long)statusCode);
                completionHandler(nil);
            }
        }
    }];
    [dataTask resume];
}


@end
