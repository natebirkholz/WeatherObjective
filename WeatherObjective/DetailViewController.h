//
//  DetailViewController.h
//  WeatherObjective
//
//  Created by Nathan Birkholz on 6/7/17.
//  Copyright © 2017 natebirkholz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Forecast.h"

@interface DetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *minTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;

@property(strong, nonatomic) Forecast *forecast;









@end
