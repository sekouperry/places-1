#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapViewController : UIViewController

@property (strong, nonatomic) MKMapView *mapView;

- (void)focusOnLocationWithDistance:(double)distance;

@end
