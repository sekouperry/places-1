#import "LocationManager.h"
#import "ExploreViewController.h"
#import "SearchViewController.h"
#import "ApiConnection.h"
#import "Venue.h"

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

    self.mapView = [[MapViewController alloc] init];
    self.mapView.view.frame = mapRect;
    self.tableView = [[UITableView alloc] initWithFrame:tableRect];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self.mapView.view addSubview:self.hideTableButton];
    [self.mapView.view addSubview:self.showTableButton];

    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchVenues)];
    self.navigationItem.rightBarButtonItem = searchButton;

    [self.view addSubview:self.mapView.view];
    [self.view addSubview:self.tableView];
    [self.mapView focusOnLocationWithDistance:500];

    [self requestLocations];
}


- (void)hideTable {
    self.hideTableButton.hidden = YES;
    [UIView animateWithDuration:0.2 animations:^{
        self.mapView.view.frame = self.view.frame;
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
    [UIView animateWithDuration:0.3 animations: ^{
        self.mapView.view.frame = self.originalMapRect;
    }];
}

- (void)requestLocations {
    CLLocationCoordinate2D location = [[[LocationManager sharedLocation] location] coordinate];
    NSString *locationString = [NSString stringWithFormat:@"%f,%f", location.latitude, location.longitude];

    void (^completionBlock)(NSArray *) = ^(NSArray *array){
        self.places = [array mutableCopy];
        [self plotPlaces];
        [self.tableView reloadData];
    };

    [ApiConnection fetchVenuesFromLocation:locationString completionHandler:completionBlock];
}

- (void)plotPlaces {
    for (Venue *venue in self.places) {
        CLLocationCoordinate2D location;
        location.latitude = [[venue.location objectForKey:@"lat"] doubleValue];
        location.longitude = [[venue.location objectForKey:@"lng"] doubleValue];
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = location;
        annotation.title = venue.name;

        [(MKMapView *)self.mapView.view addAnnotation:annotation];
    }
}

- (void)searchVenues {
    SearchViewController *exploreView = [[SearchViewController alloc] init];
    exploreView.view.frame = self.view.frame;
    exploreView.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController presentModalViewController:exploreView animated:YES];
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

@end
