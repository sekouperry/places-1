#import "VenueDetailViewController.h"
#import "VenueDetailView.h"
#import "ApiConnection.h"
#import "MapAnnotation.h"
#import "MapAnnotationView.h"
#import "Storage.h"

static const NSString *kPhotoSize = @"width500";
static NSString * const kAddToList = @"Add to list.";
static NSString * const kRemoveFromList = @"Remove from list.";

@implementation VenueDetailViewController

- (id)initWithVenue:(Venue *)venue {
    self = [super init];
    self.venue = venue;
    return self;
}

- (void)loadView {
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    _detailView = [[VenueDetailView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _detailView.nameLabel.text = self.venue.name;
    if (self.venue.address) {
        _detailView.addressLabel.text = self.venue.address;
    } else {
        _detailView.addressLabel.text = @"Exact address unavailable.";
    }
    _detailView.mapView.delegate = self;

    if ([self alreadySaved]) {
        [_detailView.addToListButton setBackgroundImage:[UIImage imageNamed:@"removeFromList"] forState:UIControlStateNormal];
        [_detailView.addToListButton setTitle:kRemoveFromList forState:UIControlStateNormal];
        [_detailView.addToListButton addTarget:self action:@selector(removeFromList) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [_detailView.addToListButton setBackgroundImage:[UIImage imageNamed:@"addToList"] forState:UIControlStateNormal];
        [_detailView.addToListButton setTitle:kAddToList forState:UIControlStateNormal];
        [_detailView.addToListButton addTarget:self action:@selector(addToList) forControlEvents:UIControlEventTouchUpInside];
    }
    [self scopeMapToVenue];
    [self.view addSubview:_detailView];
}

- (void)viewDidUnload {
    NSError *error;
    [[[Storage sharedStorage] managedObjectContext] save:&error];
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

    dispatch_async(dispatch_get_main_queue(), ^{
        _detailView.imageView.image = image;
    });
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

- (void)addToList {
    if (![self.venue isInserted]) {
        [[[Storage sharedStorage] managedObjectContext] insertObject:self.venue];
    }
    NSMutableSet *venues = [self.currentList mutableSetValueForKey:@"venues"];
    [venues addObject:self.venue];
    [_detailView.addToListButton setBackgroundImage:[UIImage imageNamed:@"removeFromList"] forState:UIControlStateNormal];
    [_detailView.addToListButton setTitle:kRemoveFromList forState:UIControlStateNormal];
    [_detailView.addToListButton addTarget:self action:@selector(removeFromList) forControlEvents:UIControlEventTouchUpInside];
    [self displayNotificationWithMessage:[NSString stringWithFormat:@"Saved to %@!", self.currentList.name]];
}

- (void)getDirections {
    MKPlacemark *place = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake([self.venue.lat floatValue], [self.venue.lng floatValue]) addressDictionary:nil];
    MKMapItem *item = [[MKMapItem alloc] initWithPlacemark:place];
    item.name = self.venue.name;
    [MKMapItem openMapsWithItems:@[item] launchOptions:nil];
}

- (void)removeFromList {
    [[self.currentList mutableSetValueForKey:@"venues"] removeObject:self.venue];
    [_detailView.addToListButton setBackgroundImage:[UIImage imageNamed:@"addToList"] forState:UIControlStateNormal];
    [_detailView.addToListButton setTitle:kAddToList forState:UIControlStateNormal];
    [_detailView.addToListButton addTarget:self action:@selector(addToList) forControlEvents:UIControlEventTouchUpInside];
    [self displayNotificationWithMessage:[NSString stringWithFormat:@"Removed from %@", self.currentList.name]];
}

- (void)displayNotificationWithMessage:(NSString *)message {
    self.view.userInteractionEnabled = NO;
    self.notification.textLabel.text = message;
    self.notification.view.alpha = 0;
    [self.view addSubview:self.notification.view];
    [UIView animateWithDuration:0.2 animations:^{
        self.notification.view.alpha = 0.8;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^{
            self.notification.view.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.view.userInteractionEnabled = YES;
        }];
    });
}

- (BOOL)alreadySaved {
    NSSet *savedVenues = self.currentList.venues;
    for (Venue *venue in savedVenues) {
        if ([venue.foursquareId isEqualToString:self.venue.foursquareId]) {
            return YES;
        }
    }
    return NO;
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

- (NotificationViewController *)notification {
    if (_notification == nil) {
        _notification = [[NotificationViewController alloc] init];
    }
    return _notification;
}

@end
