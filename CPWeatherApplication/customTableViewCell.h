//
//  customTableViewCell.h
//  CPWeatherApplication
//
//  Created by Student P_02 on 20/10/16.
//  Copyright © 2016 chaitu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface customTableViewCell : UITableViewCell



@property (strong, nonatomic) IBOutlet UILabel *dailyDayLabel;

@property (strong, nonatomic) IBOutlet UILabel *dailyMinimumTemperatureLabel;

@property (strong, nonatomic) IBOutlet UILabel *dailyMaximumTemperatureLabel;

@property (strong, nonatomic) IBOutlet UILabel *dailyHumidityLabel;


@property (strong, nonatomic) IBOutlet UILabel *dailySunrisesLabel;
@property (strong, nonatomic) IBOutlet UILabel *dailySunsetsLabel;












@end
