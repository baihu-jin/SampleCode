//
//  LocationManager.m
//  Runx
//
//  Created by Ryuang Jin on 18/12/14.
//  Copyright (c) 2014 Ryuang. All rights reserved.
//

#import "LocationManager.h"
//#import "SPGooglePlacesAutocompleteQuery.h"
//#import "SPGooglePlacesAutocompletePlace.h"
#import "appconstants.h"
#import "AppDelegate.h"
#import "RFSharedData.h"

LocationManager *g_locationManager = nil;

@interface LocationManager () <CLLocationManagerDelegate>{
    LocationManagerPostingLocationType _postingLocationType;
    NSTimer * periodicLocationUpdateTimer;
}

@end

@implementation LocationManager
#pragma mark - Data & Properties
+ (instancetype) sharedInstance {
	if ( !g_locationManager ) {
        g_locationManager = [[LocationManager alloc] init];
        g_locationManager.postingLocationType = LocationManagerPostingLocationTypePeriod;
#ifdef kBELocationSimulateGPS
        [g_locationManager startSimulatingGPS];
#endif
	}
	
	return g_locationManager;
}

+ (void) loadCoordinateByAddress:(NSString *)address completionHandler:(LocationManagerCallback)completionHandler {
	if ( !address ) {
		dispatch_async(kMainQueue, ^{
			if ( completionHandler )
				completionHandler(nil);
		});
	}
	
	NSString *strAddress = [address stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
	NSString *strUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?address=%@", strAddress];
//	NSLog(@"%@", strUrl);
	
	dispatch_async(kBgQueue, ^{
		NSData* responseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:strUrl]];
		if ( responseData.length > 0 ) {
			NSError* error;
			NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData
																 options:kNilOptions
																   error:&error];
			
			if ( error ) {
				[AppDelegate errorHandler:error.localizedDescription];
				return;
			}
			
			NSArray *results = json[@"results"];
			if ( results && [results count] > 0 ) {
				NSDictionary *geometry = results[0][@"geometry"];
				if ( geometry ) {
					
					NSDictionary *bounds = geometry[@"bounds"];
					if ( bounds ) {
						
						NSDictionary *northeast = bounds[@"northeast"];
						if ( northeast ) {
							CGFloat lat = [northeast[@"lat"] floatValue];
							CGFloat lng = [northeast[@"lng"] floatValue];
							
							dispatch_async(kMainQueue, ^{
								if ( completionHandler )
									completionHandler([Location instance:address coordinate:CLLocationCoordinate2DMake(lat, lng)]);
							});
							
							return;
						}
					}
					
					NSDictionary *locationInfo = geometry[@"location"];
					if ( locationInfo ) {
						CGFloat lat = [locationInfo[@"lat"] floatValue];
						CGFloat lng = [locationInfo[@"lng"] floatValue];
						
						dispatch_async(kMainQueue, ^{
							if ( completionHandler )
								completionHandler([Location instance:address coordinate:CLLocationCoordinate2DMake(lat, lng)]);
						});
						
						return;
					}
				}
			}
		}
	});
}

+ (void) loadAddressByLatitude:(CGFloat)latitude longitude:(CGFloat)longitude completionHandler:(LocationManagerCallback)completionHandler {
	[LocationManager loadAddressByCoordinate:CLLocationCoordinate2DMake(latitude, longitude) completionHandler:completionHandler];
}

+ (void) loadAddressByCoordinate:(CLLocationCoordinate2D)coordinate completionHandler:(LocationManagerCallback)completionHandler {
	
	GMSGeocoder *geocoder = [GMSGeocoder geocoder];
	[geocoder reverseGeocodeCoordinate:coordinate completionHandler:^(GMSReverseGeocodeResponse *response, NSError *error) {
		
		Location *location = nil;
		CLLocation *baseLocation = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
		for (GMSAddress *address in response.results) {
			CLLocation *tmpLocation = [[CLLocation alloc] initWithLatitude:address.coordinate.latitude longitude:address.coordinate.longitude];
			if ( [baseLocation distanceFromLocation:tmpLocation] < 10 ) {
				NSMutableString *locHeading = [NSMutableString stringWithFormat:@"%@", [[address lines] firstObject] ];
				if ([[address lines] count] > 1) {
					NSString *snippet = [[address lines] objectAtIndex:1];
                    [locHeading appendString:@", "];
					[locHeading appendString:snippet];
				}
				
				location = [Location instance:locHeading coordinate:address.coordinate];
				break;
			}
		}
		
		if ( !location ) {
			GMSAddress *address = response.firstResult;
			NSMutableString *locHeading = [NSMutableString stringWithFormat:@"%@", [[address lines] firstObject] ];
			if ([[address lines] count] > 1) {
				NSString *snippet = [[address lines] objectAtIndex:1];
				[locHeading appendString:snippet];
			}
			
			location = [Location instance:locHeading coordinate:address.coordinate];
		}
		
		dispatch_async(kMainQueue, ^{
			if ( completionHandler )
				completionHandler(location);
		});
	}];
}

+ (CLLocation *) currentLocation {
	return [LocationManager sharedInstance].currentLocation;
}

+ (CLLocationDegrees) latitude {
	return [LocationManager sharedInstance].currentLocation.coordinate.latitude;
}

+ (CLLocationDegrees) longitude {
	return [LocationManager sharedInstance].currentLocation.coordinate.longitude;
}

-(void) setCurrentLocation:(CLLocation *)currentLocation {
    _currentLocation = currentLocation;
}

-(void) setPostingLocationType:(LocationManagerPostingLocationType)postingLocationType {
    if (postingLocationType == LocationManagerPostingLocationTypePeriod && _postingLocationType != LocationManagerPostingLocationTypePeriod) {
        [self startPeriodicalLocationPosting];
    }
    else if (postingLocationType != LocationManagerPostingLocationTypePeriod && _postingLocationType == LocationManagerPostingLocationTypePeriod) {
        [self stopPeriodicalLocationPosting];
    }
    _postingLocationType = postingLocationType;
}
-(LocationManagerPostingLocationType) postingLocationType {
    return _postingLocationType;
}

#pragma mark - private methods
-(void) startPeriodicalLocationPosting {
    periodicLocationUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerPostLocation:) userInfo:nil repeats:YES];
}
-(void) stopPeriodicalLocationPosting {
    [periodicLocationUpdateTimer invalidate];
}
- (void)timerPostLocation:(NSTimer*)timer {
    // define
//    kBESharedData.loginUser.currentLocation = self.currentLocation;
}
#ifdef kBELocationSimulateGPS
-(void) startSimulatingGPS {

//    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(retrieveSimulatedLocation:) userInfo:nil repeats:YES];
    if (kBESharedData.loginUser) {
        [PFCloud callFunctionInBackground:@"retrieveSimulatedGPSCoord" withParameters:@{@"username":kBESharedData.loginUser.pfUserObject.username} block:^(id object, NSError *error) {
            PFGeoPoint * geoPoint = object;
            CLLocationCoordinate2D coord = [BEParseBackendHelper convertGeolocationData:geoPoint];
            self.currentLocation = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kLocationManagerDidUpdateLocationNotification object:self];
#ifndef DISABLE_LOCMAN_LOG
            NSLog(@"Location Manager : %f %f", self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude);
#endif
        }];
    }
    else {
        self.currentLocation = [[CLLocation alloc]initWithLatitude:0 longitude:0];
    }

    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BE_NOTIFICATION_NAME_REMOTE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(internalHandleRemoteNotification:) name:BE_NOTIFICATION_NAME_REMOTE object:nil];

}
-(void) internalHandleRemoteNotification:(NSNotification*) notification{


    if ([notification.userInfo[PNNotificationType] isEqualToString:PNNotificationType_locationUpdate] ) {
        CLLocationCoordinate2D coord ;
        coord.latitude = [ notification.userInfo[PNNotificationLocation][@"latitude"] floatValue];
        coord.longitude = [ notification.userInfo[PNNotificationLocation][@"longitude"] floatValue];
        //= [BEParseBackendHelper convertGeolocationData:notification.userInfo[PNNotificationLocation]];
        self.currentLocation = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
        [[NSNotificationCenter defaultCenter] postNotificationName:kLocationManagerDidUpdateLocationNotification object:self];
    }
    //[self handleRemoteNotification:notification.userInfo];

}

-(void) retrieveSimulatedLocation:(NSTimer*)timer {
    if (kBESharedData.loginUser) {
        [PFCloud callFunctionInBackground:@"retrieveSimulatedGPSCoord" withParameters:@{@"username":kBESharedData.loginUser.pfUserObject.username} block:^(id object, NSError *error) {
            PFGeoPoint * geoPoint = object;
            CLLocationCoordinate2D coord = [BEParseBackendHelper convertGeolocationData:geoPoint];
            self.currentLocation = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kLocationManagerDidUpdateLocationNotification object:self];
#ifndef DISABLE_LOCMAN_LOG
            NSLog(@"Location Manager : %f %f", self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude);
#endif
        }];
    }
    else {
        self.currentLocation = [[CLLocation alloc]initWithLatitude:0 longitude:0];
    }
    
//    BOOL valueSet = NO;
    /*
    if (kBESharedData.loginUser) {
        
        [kBESharedData.loginUser refreshDataFromBackendSuccess:^(id result) {
            PFGeoPoint * geoPoint = [kBESharedData.loginUser getModelObjectProperty:PF_USER_location];
            if (geoPoint) {
                CLLocationCoordinate2D coordinate = [BEParseBackendHelper convertGeolocationData:geoPoint];
                self.currentLocation = [[CLLocation alloc]initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
//                valueSet = YES;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kLocationManagerDidUpdateLocationNotification object:self];
                
                NSLog(@"Location Manager : %f %f", self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude);
            }
        } Failure:^(NSError *error) {
            
        }];
        
    }
     */
//    if (!valueSet) {
//        self.currentLocation = [[CLLocation alloc]initWithLatitude:0 longitude:0];
//    }
    
//    kBESharedData.loginUser.currentLocation = self.currentLocation;
    
}
#endif

#pragma mark - public methods
- (void) startLocationManager {
	self.locationManager = [[CLLocationManager alloc] init];
	self.locationManager.delegate = self;
	self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	self.locationManager.distanceFilter = 0.1f;
	if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
		[self.locationManager requestAlwaysAuthorization];
	}
	
	[self.locationManager startUpdatingLocation];
}

- (void) stopLocationManager {
	[self.locationManager stopUpdatingLocation];
}
#pragma mark - DELEGATES
#pragma mark - CLLocationManagerDelegate
- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
#ifdef kBELocationSimulateGPS
#else
	CLLocation *newLocation = [locations lastObject];
	
#ifdef SIMULATE_ELEV
    self.currentLocation = [[CLLocation alloc] initWithCoordinate:newLocation.coordinate altitude:[self simulatedAltitude] horizontalAccuracy:newLocation.horizontalAccuracy verticalAccuracy:newLocation.verticalAccuracy timestamp:[NSDate date]];
#else
    self.currentLocation = newLocation;
#endif
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kLocationManagerDidUpdateLocationNotification object:self];
#ifndef DISABLE_LOCMAN_LOG
//	NSLog(@"Location Manager : lat: %f long: %f alt: %f", self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude,self.currentLocation.altitude);
    NSLog(@"Location Manager : New Location %@", self.currentLocation);
#endif
#endif
}

-(CLLocationDistance) simulatedAltitude {
    static CLLocationDistance currentAltitude=10.f;
    static CLLocationDistance minAltitude=7.f;
    static CLLocationDistance maxAltitude=30.f;
    static int increasing=1;
    if (increasing) {
        if (currentAltitude>maxAltitude) {
            increasing=0;
        }
        else {
            currentAltitude+=0.2;
        }
    }
    else {
        if (currentAltitude<minAltitude) {
            increasing=1;
        }
        else {
            currentAltitude-=0.2;
        }
    }
    return currentAltitude;
}

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
#ifdef kBELocationSimulateGPS
#else

	self.currentLocation = newLocation;
	
    kBESharedData.loginUser.currentLocation = self.currentLocation;
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kLocationManagerDidUpdateLocationNotification object:self];
	
	NSLog(@"Location Manager : lat: %f long: %f alt: %f", self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude,self.currentLocation.altitude);
#endif
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
	
		//	double osversion = [[UIDevice currentDevice]systemVersion].doubleValue;
	switch (status) {
		case kCLAuthorizationStatusAuthorizedAlways:
			NSLog(@"Got authorization, start tracking location");
			
			break;
		case kCLAuthorizationStatusAuthorizedWhenInUse:
			NSLog(@"Got authorization, start tracking location");
			
			break;
		case kCLAuthorizationStatusNotDetermined:
			break;
		default:
			break;
	}
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
#ifdef kBELocationSimulateGPS
    return;
#endif
	
	NSString *strError;
	[manager stopUpdatingLocation];
	
	NSLog(@"Error: %@",[error localizedDescription]);
	switch ( [error code] ) {
		case kCLErrorDenied:
				//Access denied by user
			strError = @"Access to Location Services denied by user";
				//Do something...
//			[[[UIAlertView alloc] initWithTitle:@"Message："
//										message:@"Please enable location permissions!"
//									   delegate:nil
//							  cancelButtonTitle:nil
//							  otherButtonTitles:@"OK", nil] show];
			break;
		case kCLErrorLocationUnknown:
				//Probably temporary...
			strError = @"Location data unavailable";
//			[[[UIAlertView alloc] initWithTitle:@"Message："
//										message:@"Location data unavailable!"
//									   delegate:nil
//							  cancelButtonTitle:nil
//							  otherButtonTitles:@"OK", nil] show];
				//Do something else...
			break;
		default:
			strError = @"An unknown error has occurred";
//			[[[UIAlertView alloc] initWithTitle:@"Message："
//										message:@"An unknown error has occurred!"
//									   delegate:nil
//							  cancelButtonTitle:nil
//							  otherButtonTitles:@"OK", nil] show];
			break;
	}
	
	self.currentLocation = nil;
	
	[NSTimer scheduledTimerWithTimeInterval:2.f target:self selector:@selector(startLocationManager) userInfo:self repeats:NO];
	
	if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
		NSLog(@"Please authorize location services");
		return;
	}
	
	NSLog(@"Location Manager Error : %@", strError);
}

@end


@implementation Location

+ (instancetype) instance {
	return [[Location alloc] init];
}

+ (instancetype) instance:(NSString *)address coordinate:(CLLocationCoordinate2D)coordinate {
	Location *location = [Location instance];
	
	location.address = address;
	location.coordinate = coordinate;
	
	return location;
}

@end