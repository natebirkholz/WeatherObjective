//
//  ViewController.m
//  WeatherObjective
//
//  Created by Nathan Birkholz on 6/7/17.
//  Copyright © 2017 natebirkholz. All rights reserved.
//

#import "ViewController.h"
#import "WeatherCell.h"
#import "Forecast.h"
#import "DetailViewController.h"
#import "NetworkController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[self tableView] setDelegate:self];
    [[self tableView] setDataSource:self];
    [[self tableView] registerNib:[UINib nibWithNibName:@"WeatherCell" bundle: [NSBundle mainBundle]] forCellReuseIdentifier:@"WEATHER_CELL"];
    [[self navigationController] setDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    __weak typeof(self) weakSelf = self;

    [[[NetworkController sharedController] locationController] updateLocationWithCompletionHandler:^(WeatherErrorType error) {
        if (error != WeatherErrorNoError) {
            // TODO HANDLE ERROR
        }

        [[NetworkController sharedController] getArrayOfForecastsWithCompletionHandler:^(NSArray * _Nullable forecasts, WeatherErrorType error) {
            typeof(weakSelf) strongSelf = weakSelf;
            if (!strongSelf) {
                // handle error? I mean, there's no self at this point
            }

            if (error != WeatherErrorNoError) {
                // handle error
            }

            if ([forecasts count] > 0) {
                self.forecasts = forecasts;
                [[self tableView] reloadData];
            }
        }];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[self forecasts] count] > 0) {
        return [[self forecasts] count];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Forecast *forecastForCell = [[self forecasts] objectAtIndex:indexPath.row];
    WeatherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WEATHER_CELL" forIndexPath:indexPath];
    UIImage *imageForCell = [self getImageForType:[forecastForCell type]];

    [[cell weatherLabel] setText:[forecastForCell day]];
    [[cell cellImageView] setImage:imageForCell];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"SHOW_DETAIL" sender:self];
}

- (UIImage *)getImageForType:(NSString *)weatherType {
    if ([weatherType isEqualToString:@"Sunny"]) {
        return [UIImage imageNamed:@"Sunny"];
    } else if ([weatherType isEqualToString:@"Cloudy"]) {
        return [UIImage imageNamed:@"Cloudy"];
    } else {
        return [UIImage imageNamed:@"Rainy"];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"SHOW_DETAIL"]) {
        NSIndexPath *selectedPath = [[self tableView] indexPathForSelectedRow];
        if (selectedPath) {
            WeatherCell *selectedCell = [[self tableView] cellForRowAtIndexPath:selectedPath];
            DetailViewController *detailController = [segue destinationViewController];
            Forecast *selectedForecast = [[self forecasts] objectAtIndex:selectedPath.row];
            detailController.forecast = selectedForecast;
            detailController.forecastImage = [[selectedCell cellImageView] image];
        }
    }
}


@end
