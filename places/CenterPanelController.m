#import "CenterPanelController.h"
#import "ListViewController.h"
#import "ExploreViewController.h"
#import "MapAnnotation.h"
#import "MapAnnotationView.h"
#import "Venue.h"
#import "VenueDetailViewController.h"
#import "Storage.h"
#import "AppDelegate.h"

@interface CenterPanelController ()

@end

@implementation CenterPanelController

- (id)init {
    self = [super init];
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    self.mapShowing = YES;
    [self plotPlaces];
    [self.mapViewController focusCurrentLocationWithDistance:500.0];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.frame = [UIScreen mainScreen].bounds;
    self.view.backgroundColor = [UIColor whiteColor];

    UIButton *toggleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    toggleButton.frame = CGRectMake(0, 0, 44, 30);
    [toggleButton setBackgroundImage:[UIImage imageNamed:@"listView"] forState:UIControlStateNormal];
    [toggleButton addTarget:self action:@selector(toggleMap:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(0, 0, 37, 30);
    [addButton setBackgroundImage:[UIImage imageNamed:@"addLocation"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(exploreLocations) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *toggleMapButton = [[UIBarButtonItem alloc] initWithCustomView:toggleButton];
    UIBarButtonItem *addLocationButton = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    self.navigationItem.rightBarButtonItems = @[toggleMapButton, addLocationButton];

    [self addObserver:self forKeyPath:@"currentList" options:NSKeyValueObservingOptionNew context:nil];

    UIButton *showPanelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    showPanelButton.frame = CGRectMake(0, 0, 44, 30);
    [showPanelButton setBackgroundImage:[UIImage imageNamed:@"panelDisplay"] forState:UIControlStateNormal];
    JASidePanelController *sidePanelController = [(AppDelegate *)[UIApplication sharedApplication].delegate viewController];
    [showPanelButton addTarget:sidePanelController action:@selector(toggleLeftPanel:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:showPanelButton];
    self.navigationItem.leftBarButtonItem = leftBarButton;

    self.listView = [[ListViewController alloc] init];
    self.mapViewController = [[MapViewController alloc] init];
    self.mapViewController.view.frame = [[UIScreen mainScreen] bounds];
    self.mapViewController.mapView.delegate = self;
    [self.view addSubview:self.mapViewController.view];

    self.centerMapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.centerMapButton.frame = CGRectMake(20, CGRectGetMaxY(self.mapViewController.view.frame) - 120, 36, 36);
    [self.centerMapButton setBackgroundImage:[UIImage imageNamed:@"focusUser"] forState:UIControlStateNormal];
    [self.centerMapButton addTarget:self action:@selector(centerMap) forControlEvents:UIControlEventTouchUpInside];
    [self.mapViewController.view addSubview:self.centerMapButton];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBar"] forBarMetrics:UIBarMetricsDefault];

    [self getPreviousList];
}

- (void)getPreviousList {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSURL *activeList = [userDefaults URLForKey:kSelectedList];
    if (activeList != nil) {
        NSManagedObjectID *objectId = [[[Storage sharedStorage] persistentStoreCoordinator] managedObjectIDForURIRepresentation:activeList];
        self.currentList = (List *)[[[Storage sharedStorage] managedObjectContext] objectWithID:objectId];
    }
}

- (void)plotPlaces {
    NSMutableArray *currentAnnotations = [[self.mapViewController.mapView annotations] mutableCopy];
    [currentAnnotations removeObject:self.mapViewController.mapView.userLocation];
    [self.mapViewController.mapView removeAnnotations:currentAnnotations];
    for (Venue *venue in self.currentList.venues) {
        CLLocationCoordinate2D location;
        location.latitude = [venue.lat floatValue];
        location.longitude = [venue.lng floatValue];

        MapAnnotation *annotation = [[MapAnnotation alloc] init];
        annotation.title = venue.name;
        annotation.coordinate = location;
        annotation.venue = venue;

        [self.mapViewController.mapView addAnnotation:annotation];
    }
}

- (void)exploreLocations {
    if (self.mapShowing) {
        if (!self.currentList) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No List selected" message:@"Select a list to use" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        ExploreViewController *exploreViewController = [[ExploreViewController alloc] init];
        exploreViewController.currentList = self.currentList;
        [self.navigationController pushViewController:exploreViewController animated:YES];
    }
}

- (void)toggleMap:(id)sender {
    if (self.mapShowing) {
        self.listView.currentList = self.currentList;
        [UIView animateWithDuration:0.5 animations:^{
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [self.navigationController pushViewController:self.listView animated:NO];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
            self.mapShowing = NO;
        }];
    }
}

- (void)centerMap {
    [self.mapViewController focusCurrentLocationWithDistance:500.0];
}

- (void)setActiveList:(List *)list {
    self.currentList = list;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"currentList"]) {
        self.navigationItem.title = self.currentList.name;
        [self plotPlaces];
    }
}

- (void)showDetailViewControllerWithVenue:(Venue *)venue {
    VenueDetailViewController *detailViewController = [[VenueDetailViewController alloc] initWithVenue:venue];
    detailViewController.currentList = self.currentList;
    detailViewController.title = venue.name;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma MapView Delegate

- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView {
    NSLog(@"location user");
}

- (void)mapViewDidStopLocatingUser:(MKMapView *)mapView {
    NSLog(@"stopped locating user");
}

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

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    [self showDetailViewControllerWithVenue:[(MapAnnotation *)view.annotation venue]];
}

@end
