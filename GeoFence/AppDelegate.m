//
//  AppDelegate.m
//  GeoFence
//
//  Created by 石田 勝嗣 on 2014/09/16.
//  Copyright (c) 2014年 石田 勝嗣. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate () <CLLocationManagerDelegate>
@property CLLocationManager *manager;
@property CLCircularRegion *distCircularRegion;
@property CLLocationCoordinate2D location;
@end

@implementation AppDelegate

const CLLocationDegrees LATITUDE = 35.697223;
const CLLocationDegrees LONGITUDE = 139.769239;
const CLLocationDistance RADIUS = 150.;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.manager = [[CLLocationManager alloc] init];
    [self.manager setDelegate:self];
    self.location = CLLocationCoordinate2DMake(LATITUDE, LONGITUDE);
    
    self.distCircularRegion = [[CLCircularRegion alloc]initWithCenter:self.location radius:RADIUS identifier:@"神田"];
    
    UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
    
    return YES;
}

- (void)startMonitor {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusNotDetermined) {
        [self.manager requestAlwaysAuthorization];
    }
    [self.manager startMonitoringForRegion:self.distCircularRegion];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways:
            NSLog(@"Got authorization, start tracking location");
            [self startMonitor];
            break;
        case kCLAuthorizationStatusNotDetermined:
            [self.manager requestAlwaysAuthorization];
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    //[self.manager requestStateForRegion:region];
    NSLog(@"Started Monitoring for Circular Region %@", region);
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    NSLog(@"Did Enter Region!! %@", region);
    
    UILocalNotification *notification = [UILocalNotification new];
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    notification.alertBody = [NSString stringWithFormat:@"%@ に入りました。", region.identifier];
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSLog(@"Did Exit Region");
    
    UILocalNotification *notification = [UILocalNotification new];
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    notification.alertBody = [NSString stringWithFormat:@"%@ から出ました。", region.identifier];
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

-(void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSLog(@"failed for region %@", region);
    NSLog(@"error=%@", error);
    
    UILocalNotification *notification = [UILocalNotification new];
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    notification.alertBody = @"エラーです。";
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}
@end
