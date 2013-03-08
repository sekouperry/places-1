#import "SearchViewController.h"
#import "ApiConnection.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

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
    [self.mapView.view addSubview:self.hideTableButton];
    [self.mapView.view addSubview:self.showTableButton];

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
    NSArray *locations = [ApiConnection fetchLocations:@"40.7,-74"];
    NSLog(@"%@", locations);
}

@end
