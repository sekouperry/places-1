#import "LocationManager.h"

@implementation LocationManager

- (id)init {
    self = [super init];
    self.delegate = self;
    self.distanceFilter = kCLDistanceFilterNone;
    self.desiredAccuracy = kCLLocationAccuracyBest;
    [self startUpdatingLocation];
    return self;
}

+ (id)sharedLocation {
    __strong static LocationManager *locationManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        locationManager = [[self alloc] init];
        
    });
    return locationManager;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"failed to find location %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"Location managaer did update location");
}

@end
