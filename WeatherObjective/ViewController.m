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
#import "TransitionToDetailController.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - Lifecycle

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
            [self handleError:error];
        }

        [[NetworkController sharedController] getArrayOfForecastsWithCompletionHandler:^(NSArray * _Nullable forecasts, WeatherErrorType error) {
            typeof(weakSelf) strongSelf = weakSelf;
            if (!strongSelf) {
                [weakSelf handleError:WeatherErrorMissingInstance];
                return;
            }

            if (error != WeatherErrorNoError) {
                [strongSelf handleError:error];
                return;
            }

            if ([forecasts count] > 0) {
                [self setForecasts:forecasts];
                [[self tableView] reloadData];
            }
        }];
    }];
}

#pragma mark - TableView

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

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"SHOW_DETAIL"]) {
        NSIndexPath *selectedPath = [[self tableView] indexPathForSelectedRow];
        if (selectedPath) {
            WeatherCell *selectedCell = [[self tableView] cellForRowAtIndexPath:selectedPath];
            DetailViewController *detailController = (DetailViewController *)[segue destinationViewController];
            Forecast *selectedForecast = [[self forecasts] objectAtIndex:selectedPath.row];
            [detailController setForecast:selectedForecast];
            [detailController setForecastImage:[[selectedCell cellImageView] image]];
        }
    }
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if ([fromVC isEqual:self] && [toVC isKindOfClass:[DetailViewController class]]) {
        return [[TransitionToDetailController alloc] init];
    } else {
        return nil;
    }
}

#pragma mark - Error handling

- (void)handleError:(WeatherErrorType)weatherError {
    switch (weatherError) {
        case WeatherErrorParseError:
            [self showError:@"The data from the server was not recognizd. Please try again shortly."];
            break;
        case WeatherErrorNetworkError:
            [self showError:@"Unable to reach the server. Please check your Internet connection and try again."];
            break;
        case WeatherErrorLocationError:
            [self showError:@"Unable to determine your location. Attempting to display the weather in sunny San Diego, instead."];
            break;
        default:
            [self showError:@"An unknown error occurred. Please check your Internet connection and try again soon."];
            break;
    }

}

- (void)showError:(NSString *)errorMessge {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:errorMessge preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}


@end
