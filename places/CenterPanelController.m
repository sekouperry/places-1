#import "CenterPanelController.h"
#import "ListViewController.h"
#import "SearchViewController.h"

@interface CenterPanelController ()

@end

@implementation CenterPanelController

- (id)init {
    self = [super init];

    self.view.frame = [UIScreen mainScreen].bounds;
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *toggleMapButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(toggleMap:)];
    UIBarButtonItem *addLocationButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addLocation)];
    self.navigationItem.rightBarButtonItems = @[toggleMapButton, addLocationButton];

    self.listView = [[ListViewController alloc] init];
    self.mapView = [[MapViewController alloc] init];
    self.mapView.view.frame = [[UIScreen mainScreen] bounds];
    [self.view addSubview:self.mapView.view];
    [self.mapView focusOnLocationWithDistance:500.0];
    self.mapShowing = YES;

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)addLocation {
    if (self.mapShowing) {
        SearchViewController *searchViewController = [[SearchViewController alloc] init];
        [self.navigationController pushViewController:searchViewController animated:YES];
    }
}

- (void)toggleMap:(id)sender {
    if (self.mapShowing) {
        [UIView transitionFromView:self.view toView:self.listView.view duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
            self.mapShowing = NO;
        }];
    } else {
        [UIView transitionFromView:self.listView.view toView:self.view duration:1.0 options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished) {
            self.mapShowing = YES;
        }];
    }
}

@end
