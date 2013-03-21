#import "LocationManager.h"
#import "ExploreViewController.h"
#import "SearchViewController.h"
#import "ApiConnection.h"
#import "Venue.h"
#import "MapAnnotation.h"
#import "MapAnnotationView.h"
#import "VenueDetailViewController.h"

@interface ExploreViewController ()

@end

@implementation ExploreViewController

- (id)init {
    self = [super init];
    self.view.frame = [[UIScreen mainScreen] bounds];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect mapRect;
    CGRect tableRect;
    CGRectDivide(self.view.bounds, &mapRect, &tableRect, CGRectGetHeight(self.view.bounds)*0.2, CGRectMinYEdge);
    self.originalMapRect = mapRect;
    self.originalTableRect = tableRect;

    self.hideTableButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.hideTableButton addTarget:self action:@selector(hideTable) forControlEvents:UIControlEventTouchDown];
    self.hideTableButton.frame = mapRect;

    self.showTableButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.showTableButton addTarget:self action:@selector(showTable) forControlEvents:UIControlEventTouchUpInside];
    self.showTableButton.frame = CGRectMake(20, 350, 30, 30);
    self.showTableButton.hidden = YES;

    self.mapViewController = [[MapViewController alloc] init];
    self.mapViewController.view.frame = mapRect;
    self.mapViewController.mapView.frame = mapRect;
    self.mapViewController.mapView.delegate = self;

    self.tableView = [[UITableView alloc] initWithFrame:tableRect];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self.mapViewController.view addSubview:self.hideTableButton];
    [self.mapViewController.view addSubview:self.showTableButton];

    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchVenues)];
    self.navigationItem.rightBarButtonItem = searchButton;

    [self.view addSubview:self.mapViewController.view];
    [self.view addSubview:self.tableView];
    [self.mapViewController focusCurrentLocationWithDistance:500];

    [self requestLocations];
}

- (void)hideTable {
    self.hideTableButton.hidden = YES;
    [UIView animateWithDuration:0.2 animations:^{
        self.mapViewController.view.frame = self.view.frame;
        self.mapViewController.mapView.frame = self.view.frame;
    }];
    [UIView animateWithDuration:0.3 animations: ^{
        self.tableView.frame = CGRectOffset(self.tableView.frame, 0, 400);
        self.showTableButton.hidden = NO;
    }];
}

- (void)showTable {
    self.hideTableButton.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.tableView.frame = self.originalTableRect;
        self.showTableButton.hidden = NO;
    }];
    [UIView animateWithDuration:0.3 animations:^{
        self.mapViewController.mapView.frame = self.originalMapRect;
    }];
}

- (void)requestLocations {
    CLLocationCoordinate2D location = [[[LocationManager sharedLocation] location] coordinate];

    void (^completionBlock)(NSArray *) = ^(NSArray *array){
        self.places = [array mutableCopy];
        [self plotPlaces];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        });
    };

    [ApiConnection fetchVenuesFromLocation:location completionHandler:completionBlock];
    [self.mapViewController focusCurrentLocationWithDistance:500];
}

- (void)plotPlaces {
    for (Venue *venue in self.places) {
        CLLocationCoordinate2D location;
        location.latitude = [venue.lat floatValue];
        location.longitude = [venue.lng floatValue];

        MapAnnotation *annotation = [[MapAnnotation alloc] init];
        annotation.title = venue.name;
        annotation.coordinate = location;
        annotation.venue = venue;

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mapViewController.mapView addAnnotation:annotation];
        });
    }
}

- (void)searchVenues {
    SearchViewController *searchView = [[SearchViewController alloc] init];
    searchView.currentList = searchView.currentList;
    searchView.view.frame = self.view.frame;
    searchView.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:searchView animated:YES];
}

- (void)showDetailViewControllerWithVenue:(Venue *)venue {
    VenueDetailViewController *detailViewController = [[VenueDetailViewController alloc] initWithVenue:venue];
    detailViewController.currentList = self.currentList;
    detailViewController.title = venue.name;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma MapView Delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }

    static NSString *identifier = @"AnnotationIdentifier";
    MapAnnotationView *annotationView = (MapAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];

    if (annotationView == nil) {
        annotationView = [[MapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [[(MapAnnotation *)annotation venue] iconUrl], @"64.png"]];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            __block NSData *imageData;
            dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                imageData = [NSData dataWithContentsOfURL:imageURL];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    annotationView.imageView.image = [UIImage imageWithData:imageData];
                });
            });
        });
        annotationView.canShowCallout = YES;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    [self showDetailViewControllerWithVenue:[(MapAnnotation *)view.annotation venue]];
}

#pragma UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"placeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [[self.places objectAtIndex:indexPath.row] name];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.places count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self showDetailViewControllerWithVenue:[self.places objectAtIndex:indexPath.row]];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
