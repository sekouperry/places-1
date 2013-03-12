#import "LocationManager.h"
#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (id)init {
    self = [super init];
    self.view = [[MKMapView alloc] init];
    [(MKMapView *)self.view setShowsUserLocation:YES];
    return self;
}

- (void)focusCurrentLocationWithDistance:(double)distance {
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance([[LocationManager sharedLocation] location].coordinate, distance, distance);
    [(MKMapView *)self.view setRegion:viewRegion];
    
}

@end
