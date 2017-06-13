//
//  LocationController.m
//  WeatherObjective
//
//  Created by Nathan Birkholz on 6/8/17.
//  Copyright © 2017 natebirkholz. All rights reserved.
//

#import "LocationController.h"

@implementation LocationController

- (instancetype)init {
    if (self = [super init]) {
        self.locationManager = [[CLLocationManager alloc] init];
        [[self locationManager] setDelegate:self];
        [[self locationManager] setDistanceFilter:kCLDistanceFilterNone];
        [[self locationManager] setDesiredAccuracy:kCLLocationAccuracyKilometer];

        self.geocoder = [[CLGeocoder alloc] init];

        self.currentZipCode = @"92102";

        switch ([CLLocationManager authorizationStatus]) {
            case kCLAuthorizationStatusNotDetermined:
                [[self locationManager] requestWhenInUseAuthorization];
                break;

            case kCLAuthorizationStatusAuthorizedWhenInUse:
                [[self locationManager] startUpdatingLocation];
                
            default:
                break;
        }
    }

    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = locations[0];
    __weak typeof(self) weakSelf = self;
    [[self geocoder] reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {

        typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) { return; }
        if (error) { return; }

        if ([placemarks count] > 0) {
            CLPlacemark *place = placemarks[0];
            strongSelf.currentZipCode = [place postalCode];
        } else {
            NSLog(@"Zero places found");
        }
    }];
}

- (void)updateLocationWithCompletionHandler:(void (^_Nonnull)(WeatherErrorType error))completionHandler {
    CLLocation *currentLocation = [[self locationManager] location];
    __weak typeof(self) weakSelf = self;
    [[self geocoder] reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            completionHandler(WeatherErrorMissingInstance);
            return;
        }
        if (error) {
            self.currentZipCode = @"92102";
            completionHandler(WeatherErrorLocationError);
            return;
        }

        if ([placemarks count] > 0) {
            CLPlacemark *place  = [placemarks firstObject];
            NSString *zip = [place postalCode];
            if (zip) {
                self.currentZipCode = zip;
                completionHandler(WeatherErrorNoError);
            } else {
                completionHandler(WeatherErrorLocationError);
            }
        } else {
            completionHandler(WeatherErrorLocationError);
        }
    }];
}

@end
