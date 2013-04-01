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

    _exploreView = [[ExploreView alloc] initWithFrame:self.view.frame];
    self.view = _exploreView;

    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton setBackgroundImage:[UIImage imageNamed:@"searchButton"] forState:UIControlStateNormal];
    searchButton.frame = CGRectMake(0, 0, 37, 30);
    [searchButton addTarget:self action:@selector(searchVenues) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *searchBarItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    self.navigationItem.rightBarButtonItem = searchBarItem;

    self.exploreView.mapViewController.mapView.delegate = self;
    [self.exploreView.mapViewController focusCurrentLocationWithDistance:500];

    self.exploreView.tableView.delegate = self;
    self.exploreView.tableView.dataSource = self;

    [self.exploreView.showTableButton addTarget:self action:@selector(showTable) forControlEvents:UIControlEventTouchUpInside];
    [self.exploreView.searchAreaButton addTarget:self action:@selector(searchArea) forControlEvents:UIControlEventTouchUpInside];
    [self.exploreView.hideTableButton addTarget:self action:@selector(hideTable) forControlEvents:UIControlEventTouchUpInside];
    [self.exploreView.loadingPlaceholder.refreshButton addTarget:self action:@selector(requestLocations) forControlEvents:UIControlEventTouchUpInside];
    [self requestLocations];
}

- (void)hideTable {
    self.exploreView.hideTableButton.hidden = YES;
    self.exploreView.searchAreaButton.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.exploreView.mapViewController.view.frame = self.view.frame;
        self.exploreView.mapViewController.mapView.frame = self.view.frame;
    }];
    [UIView animateWithDuration:0.3 animations: ^{
        self.exploreView.tableView.frame = CGRectOffset(self.exploreView.tableView.frame, 0, 400);
        self.exploreView.showTableButton.hidden = NO;
    }];
}

- (void)showTable {
    self.exploreView.hideTableButton.hidden = NO;
    self.exploreView.searchAreaButton.hidden = YES;
    [UIView animateWithDuration:0.2 animations:^{
        self.exploreView.tableView.frame = self.exploreView.originalTableRect;
        self.exploreView.showTableButton.hidden = YES;
    }];
    [UIView animateWithDuration:0.3 animations:^{
        self.exploreView.mapViewController.mapView.frame = self.exploreView.originalMapRect;
    }];
}

- (void)searchArea {
    void (^completionBlock)(NSArray *) = ^(NSArray *array){
        self.places = [array mutableCopy];
        [self plotPlaces];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.exploreView.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        });
    };
    [ApiConnection fetchVenuesFromLocation:[self.exploreView.mapViewController.mapView centerCoordinate] completionHandler:completionBlock];
}

- (void)requestLocations {
    [self.exploreView.loadingPlaceholder swingLabel];
    CLLocationCoordinate2D location = [[[LocationManager sharedLocation] location] coordinate];

    [ApiConnection fetchVenuesFromLocation:location completionHandler:^(NSArray *array) {
        self.places = [array mutableCopy];
        if (!self.places) {
            self.exploreView.loadingPlaceholder.messageLabel.text = @"Error finding places.";
            [self.exploreView.loadingPlaceholder errorAnimation];
            return;
        }
        
        [self plotPlaces];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.exploreView.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            [self.exploreView.loadingPlaceholder removeFromSuperview];
            [self.view addSubview:self.exploreView.tableView];
        });
    }];

    [self.exploreView.mapViewController focusCurrentLocationWithDistance:500];
}

- (void)plotPlaces {
    [self.exploreView.mapViewController.mapView removeAnnotations:self.exploreView.mapViewController.mapView.annotations];
    for (Venue *venue in self.places) {
        CLLocationCoordinate2D location;
        location.latitude = [venue.lat floatValue];
        location.longitude = [venue.lng floatValue];

        MapAnnotation *annotation = [[MapAnnotation alloc] init];
        annotation.title = venue.name;
        annotation.coordinate = location;
        annotation.venue = venue;

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.exploreView.mapViewController.mapView addAnnotation:annotation];
        });
    }
}

- (void)searchVenues {
    SearchViewController *searchView = [[SearchViewController alloc] init];
    searchView.currentList = self.currentList;
    searchView.view.frame = self.view.frame;
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

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            __block NSData *imageData;
            dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
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
    [self.exploreView.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
