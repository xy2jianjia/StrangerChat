//
//  EyeLuckViewController.h
//  StrangerChat
//
//  Created by long on 15/10/30.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface EyeLuckViewController : UIViewController <CLLocationManagerDelegate>

// 定位使用
@property(nonatomic, retain) CLLocationManager *locationManager;
@property(nonatomic, retain) CLGeocoder *geocoder;
@property (nonatomic,strong) NSString *latitudeStr;
@property (nonatomic,strong) NSString *longitudeStr;

@end
