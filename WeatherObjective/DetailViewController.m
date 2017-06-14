//
//  DetailViewController.m
//  WeatherObjective
//
//  Created by Nathan Birkholz on 6/7/17.
//  Copyright © 2017 natebirkholz. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *maxTempString = [NSString stringWithFormat:@"Max: %ld°", self.forecast.maxTemp];
    NSString *minTempString = [NSString stringWithFormat:@"Min: %ld°", self.forecast.minTemp];
    NSString *humidityString = [NSString stringWithFormat:@"Humidity: %ld%%", self.forecast.humidity];

    [[self imageView] setImage:self.forecastImage];
    [[self weatherLabel] setText:self.forecast.type];
    [[self maxTempLabel] setText:maxTempString];
    [[self minTempLabel] setText:minTempString];
    [[self humidityLabel] setText:humidityString];
}

@end
