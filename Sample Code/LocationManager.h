//
//  LocationManager.h
//  Runx
//
//  Created by Ryuang Jin on 06/03/15.
//  Copyright (c) 2015 Ryuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>

#define kLocationManagerDidUpdateLocationNotification					@"kLocationManagerDidUpdateLocationNotification"
#define kLocationManagerInstance [LocationManager sharedInstance]
@class Location;

typedef void (^LocationManagerCallback)(Location *location);

typedef enum : NSUInteger {
    LocationManagerPostingLocationTypeNone,
    LocationManagerPostingLocationTypeRealTime,
    LocationManagerPostingLocationTypePeriod,
} LocationManagerPostingLocationType;

@interface LocationManager : NSObject

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *currentLocation;

+ (instancetype) sharedInstance;

+ (void) loadCoordinateByAddress:(NSString *)address completionHandler:(LocationManagerCallback)completionHandler;
+ (void) loadAddressByLatitude:(CGFloat)latitude longitude:(CGFloat)longitude completionHandler:(LocationManagerCallback)completionHandler;
+ (void) loadAddressByCoordinate:(CLLocationCoordinate2D)coordinate completionHandler:(LocationManagerCallback)completionHandler;

@property(nonatomic,readwrite) LocationManagerPostingLocationType postingLocationType;


+ (CLLocation *) currentLocation;
+ (CLLocationDegrees) latitude;
+ (CLLocationDegrees) longitude;

- (void) startLocationManager;
- (void) stopLocationManager;

@end


@interface Location : NSObject

@property (nonatomic, strong) NSString *address;
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;

+ (instancetype) instance;
+ (instancetype) instance:(NSString *)address coordinate:(CLLocationCoordinate2D)coordinate;

@end