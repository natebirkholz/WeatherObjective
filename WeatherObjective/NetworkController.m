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
    }

    return self;
}

- (void)getArrayOfForecastsWithCompletionHandler:(void (^)(NSArray *forecasts))completionHandler {



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
