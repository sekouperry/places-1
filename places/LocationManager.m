#import "LocationManager.h"

@implementation LocationManager

- (id)init {
    self = [super init];
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

@end
