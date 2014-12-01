//
//  AppDelegate.h
//  GeoFence
//
//  Created by 石田 勝嗣 on 2014/09/16.
//  Copyright (c) 2014年 石田 勝嗣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

extern const CLLocationDegrees LONGITUDE;
extern const CLLocationDegrees LATITUDE;
extern const CLLocationDistance RADIUS;
@end

