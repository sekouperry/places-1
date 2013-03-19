#import "LocationManager.h"
#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    [self.view addSubview:self.mapView];
    [self.mapView setShowsUserLocation:YES];
}

- (void)focusCurrentLocationWithDistance:(double)distance {
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance([[LocationManager sharedLocation] location].coordinate, distance, distance);
    [self.mapView setRegion:viewRegion];
}

@end
