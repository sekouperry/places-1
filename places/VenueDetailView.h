#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MapViewController.h"

@interface VenueDetailView : UIView

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIButton *addToListButton;
@property (strong, nonatomic) UIButton *getDirectionsButton;

@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) UILabel *openingHoursLabel;

@end
