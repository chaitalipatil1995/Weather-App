//
//  ViewController.m
//  CPWeatherApplication
//
//  Created by Student P_02 on 20/10/16.
//  Copyright © 2016 chaitu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)startDetectingLocation{
    
    self.latitudeLabel.text = @"";
    self.longitudeLabel.text = @"";
    myLocation = [[CLLocationManager alloc]init];
    myLocation.delegate = self;
    [myLocation setDesiredAccuracy:kCLLocationAccuracyBest];
    [myLocation requestWhenInUseAuthorization];
    [myLocation startUpdatingLocation];

}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    self.latitudeLabel.text = @"";
    self.longitudeLabel.text = @"";
    CLLocation *currentLocation = [locations lastObject];
    
    NSLog(@"Latitude:%0.2f",currentLocation.coordinate.latitude);
    NSLog(@"Longitude:%0.2f",currentLocation.coordinate.longitude);
    
    
    latitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
    longitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
    
    self.latitudeLabel.text = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
    self.longitudeLabel.text = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
    
    if (currentLocation != nil) {
        [myLocation stopUpdatingLocation];
        
    }
    
    [self getCurrentWeatherDataWithLatitude:latitude longitude:longitude APIKey:@KWeatherAPIKey];
    
    [self getForecastWeatherDataWithLatitude:latitude longitude:longitude APIKey:@KWeatherAPIKey];
    
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    NSLog(@"%@",error.localizedDescription);
    
}



-(void)getCurrentWeatherDataWithLatitude:(NSString *) latitude
                               longitude:(NSString *) longitude
                                  APIKey:(NSString *)key {
    
    
    //URLString for current weather condition
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%@&lon=%@&APPID=%@&units=metric",latitude,longitude,key];
    
    NSLog(@"%@",urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSession *mySession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDataTask *task = [mySession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            //alert
            NSLog(@"error:%@",error.localizedDescription);
        }
        else {
            if (response) {
                
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                
                if (httpResponse.statusCode == 200) {
                    
                    if (data) {
                        
                        // starting of JSON Parsing here
                        
                        NSError *error;
                        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                        
                        if (error) {
                            //alert
                        }
                        else{
                            
                            [self performSelectorOnMainThread:@selector(updateUI:) withObject:jsonDictionary waitUntilDone:NO];
                            
                        }
                    }
                    else {
                        //alert
                    }
                }
                else {
                    //alert
                }
            }
            else {
                //alert
            }
        }
    }];
    
    [task resume];
    
}



-(void)getForecastWeatherDataWithLatitude:(NSString *) latitude
                                longitude:(NSString *) longitude
                                   APIKey:(NSString *)key {
    //URLString for 7 day weather
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?lat=%@&lon=%@&cnt=7&mode=json&appid=%@&units=metric",latitude,longitude,key];
    
    NSLog(@"%@",urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSession *mySession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDataTask *task = [mySession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            //alert
            NSLog(@"error:%@",error.localizedDescription);
        }
        else {
            if (response) {
                
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                
                if (httpResponse.statusCode == 200) {
                    
                    if (data) {
                        //start json parsing
                        
                        
                        NSError *error;
                        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                        
                        if (error) {
                            //alert
                        }
                        else{
                            [self performSelectorOnMainThread:@selector(updateUIForForcast:) withObject:jsonDictionary waitUntilDone:NO];
                            
                        }
                    }
                    else {
                        //alert
                    }
                }
                else {
                    //alert
                }
            }
            else {
                //alert
            }
        }
    }];
    
    [task resume];
    
}


//Update UI method for current weather condition

-(void)updateUI:(NSDictionary *)currentWeatherResultDictionary {
    
    NSLog(@"%@",currentWeatherResultDictionary);
    
    NSString *temperature = [NSString stringWithFormat:@"%@",[currentWeatherResultDictionary valueForKeyPath:@"main.temp"]];
    
    NSLog(@"\n\nTEMPERATURE BEFORE : %@",temperature);
    
    int temp = temperature.intValue;
    
    temperature = [NSString stringWithFormat:@"%d °C",temp];
    
    
    NSLog(@"\n\nTEMPERATURE AFTER: %@",temperature);
    
    NSArray *weather = [currentWeatherResultDictionary valueForKey:@"weather"];
    
    NSLog(@"%@",weather);
    
    NSDictionary *weatherDictionary = weather.firstObject;
    
    NSString *condition = [NSString stringWithFormat:@"%@",[weatherDictionary valueForKey:@"description"]];
    
    NSLog(@"%@",condition);
    
    
    NSString *city = [NSString stringWithFormat:@"%@",[currentWeatherResultDictionary valueForKey:@"name"]];
    
    
    self.cityLabel.text = city;
    self.CurrentConditionlabel.text = condition.capitalizedString;
    self.temperatureLabel.text = temperature;
    
    
    
}
/*
 for day time date
 
 
 dataList = [dailyForecastWeatherDictionary valueForKey:@"list"];
 
 NSString *unix = [NSString stringWithFormat:@"%@",[dataList valueForKey:@"dt"]];
 
 NSLog(@"%d",unix.intValue);
 
 double unixTimeStamp = unix.intValue;
 
 NSTimeInterval _interval  =   unixTimeStamp;
 
 NSDate *date = [NSDate dateWithTimeIntervalSinceNow:_interval];
 
 NSDateFormatter *formatterDate= [[NSDateFormatter alloc] init];
 NSDateFormatter *formatterDay= [[NSDateFormatter alloc] init];
 
 NSDateFormatter *formatterHours= [[NSDateFormatter alloc] init];
 
 
 [formatterDate setLocale:[NSLocale currentLocale]];
 [formatterDay setLocale:[NSLocale currentLocale]];
 
 [formatterHours setLocale:[NSLocale currentLocale]];
 
 
 [formatterDate setDateFormat:@"MMMM dd yyyy"];
 
 [formatterDay setDateFormat:@"EEEE"];
 
 [formatterHours setDateFormat:@"HH:mm:ss"];
 
 
 NSString *dateString = [formatterDate stringFromDate:date];
 dayString = [formatterDay stringFromDate:date];
 NSString *hoursString = [formatterHours stringFromDate:date];
 
 
 NSLog(@"%@",dateString);
 NSLog(@"%@",dayString);
 NSLog(@"%@",hoursString);
 
 
 */

//Update UI method for 7 day weather condition

-(void)updateUIForForcast:(NSDictionary *)resultDictionary {
    
    list = [resultDictionary valueForKey:@"list"];
    
    [self.ForecastTableView reloadData];
}

// methods for Forecast Table

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return list.count;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    customTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"forecastData_cell"];
    
    
    NSDictionary *dailyForecastWeatherDictionary = [list objectAtIndex:indexPath.row];
    
    NSString *unix = [dailyForecastWeatherDictionary valueForKey:@"dt"];
    
    NSLog(@"%d",unix.intValue);
    
    double unixTimeStamp =unix.intValue;
    NSTimeInterval interval = unixTimeStamp;
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:interval];
    
    NSDateFormatter *formatterDay = [[ NSDateFormatter alloc]init];
    
    [formatterDay setLocale:[NSLocale currentLocale]];
    [formatterDay setDateFormat:@"EEEE"];
    NSString *dayString = [formatterDay stringFromDate:date];
    
    
    //getting forecast data on table view
    
    
    cell.dailyDayLabel.text = [NSString stringWithFormat:@"%@",dayString];

    cell.dailyMinimumTemperatureLabel.text = [NSString stringWithFormat:@"%@",[dailyForecastWeatherDictionary valueForKeyPath:@"temp.day"]];
    
    cell.dailyMinimumTemperatureLabel.text = [NSString stringWithFormat:@"%@",[dailyForecastWeatherDictionary valueForKeyPath:@"temp.min"]];
    
    cell.dailyMaximumTemperatureLabel.text = [NSString stringWithFormat:@"%@",[dailyForecastWeatherDictionary valueForKeyPath:@"temp.max"]];
    
    
    cell.dailyHumidityLabel.text = [NSString stringWithFormat:@"%@",[dailyForecastWeatherDictionary valueForKey:@"humidity"]];
    
    cell.dailySunrisesLabel.text = [NSString stringWithFormat:@"%@",[dailyForecastWeatherDictionary valueForKeyPath:@"temp.morn"]];
    
    cell.dailySunsetsLabel.text = [NSString stringWithFormat:@"%@",[dailyForecastWeatherDictionary valueForKeyPath:@"temp.night"]];
    
    
//    NSString *dt= [dailyForecastWeatherDictionary valueForKey:@"dt"];
//    
//    NSTimeInterval time = dt.doubleValue;
//    
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time ];
//    
////    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
////    
////    [dateFormat setDateFormat:@"dd MMM yyyy HH:mm a Z EEEE"];
////   // NSString *day = [dateFormat stringFromDate:date];
////    
////    NSDateFormatter *formatterDay= [[NSDateFormatter alloc] init];
//
//    NSDateFormatter *formatterDate= [[NSDateFormatter alloc] init];
//
//    NSString *day = [formatterDate stringFromDate:date];
//    
//    
    
    
    //cell.dailyDayLabel.text = day;
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    return  cell;
}

- (IBAction)startDetectingWeatherAction:(id)sender {
    
    [self startDetectingLocation];
}
@end

