//
//  ViewController.h
//  CPWeatherApplication
//
//  Created by Student P_02 on 20/10/16.
//  Copyright © 2016 chaitu. All rights reserved.
//


#define KWeatherAPIKey "dadda7e52d90d9348dc588ce9294a5e4"

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#import "customTableViewCell.h"


@interface ViewController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    
    CLLocationManager *myLocation;
    
    NSString *latitude;
    
    NSString *longitude;
    
    NSArray *list;
    
    NSArray *dataList;
    NSString *dayString;
    
    
}
@property (strong, nonatomic) IBOutlet UIButton *startDetectingAction;
@property (strong, nonatomic) IBOutlet UITableView *ForecastTableView;
@property (strong, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (strong, nonatomic) IBOutlet UILabel *cityLabel;
@property (strong, nonatomic) IBOutlet UILabel *latitudeLabel;

@property (strong, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (strong, nonatomic) IBOutlet UILabel *CurrentConditionlabel;


- (IBAction)startDetectingWeatherAction:(id)sender;












@end

