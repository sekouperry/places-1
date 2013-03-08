#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (id)init {
    self = [super init];
    self.locationManager.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager startUpdatingLocation];

    self.view = [[MKMapView alloc] init];
    [(MKMapView *)self.view setShowsUserLocation:YES];
    return self;
}

- (void)focusOnLocationWithDistance:(double)distance {
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.locationManager.location.coordinate, distance, distance);
    [(MKMapView *)self.view setRegion:viewRegion];
    
}

#pragma mark - Location Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"%@", locations);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Error loading location");
}


@end
