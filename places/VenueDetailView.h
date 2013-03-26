#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MapViewController.h"

@interface VenueDetailView : UIView

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *addressLabel;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIButton *addToListButton;

@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) UILabel *openingHoursLabel;

@property (strong, nonatomic) UIView *middleSection;
@property (strong, nonatomic) UIView *bottomSection;

@end
