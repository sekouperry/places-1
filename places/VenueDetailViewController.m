#import "VenueDetailViewController.h"
#import "VenueDetailView.h"
#import "ApiConnection.h"
#import "MapAnnotation.h"
#import "MapAnnotationView.h"

static const NSString *kPhotoSize = @"width500";

@implementation VenueDetailViewController

- (id)initWithVenue:(Venue *)venue {
    self = [super init];
    self.venue = venue;
    self.view.backgroundColor = [UIColor whiteColor];
    _detailView = [[VenueDetailView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _detailView.nameLabel.numberOfLines = 2;
    _detailView.nameLabel.text = [NSString stringWithFormat:@"%@\n %@", venue.name, venue.address];
    _detailView.mapView.delegate = self;
    [self scopeMapToVenue];
    [self.view addSubview:_detailView];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    void (^completionBlock)(NSDictionary *) = ^(NSDictionary *photo){
        self.venuePhotoDetails = photo;
        [self displayImage];
        
    };
    [ApiConnection fetchPhotosFromVenue:self.venue.foursquareId completionHandler:completionBlock];
}

- (void)displayImage {
    NSString *photoURL = [NSString stringWithFormat:@"%@%@%@", [self.venuePhotoDetails objectForKey:@"prefix"], kPhotoSize, [self.venuePhotoDetails objectForKey:@"suffix"]];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:photoURL]]];
    _detailView.imageView.image = image;
}

- (void)scopeMapToVenue {
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake([self.venue.lat floatValue], [self.venue.lng floatValue]);

    MapAnnotation *annotation = [[MapAnnotation alloc] init];
    annotation.coordinate = location;
    annotation.title = self.venue.name;
    annotation.venue = self.venue;

    [self.detailView.mapView addAnnotation:annotation];

    self.detailView.mapView.region = MKCoordinateRegionMakeWithDistance(location, 200, 200);
}

#pragma mark MapView Delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }

    static NSString *identifier = @"AnnotationIdentifier";
    MapAnnotationView *annotationView = (MapAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];

    if (annotationView == nil) {
        annotationView = [[MapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [[(MapAnnotation *)annotation venue] iconUrl], @"64.png"]];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        annotationView.imageView.image = [UIImage imageWithData:imageData];
        annotationView.canShowCallout = YES;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    return annotationView;
}


@end
