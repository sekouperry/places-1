#import "CenterPanelController.h"
#import "ListViewController.h"
#import "ExploreViewController.h"

@interface CenterPanelController ()

@end

@implementation CenterPanelController

- (id)init {
    self = [super init];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.frame = [UIScreen mainScreen].bounds;
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *toggleMapButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(toggleMap:)];
    UIBarButtonItem *addLocationButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addLocation)];
    self.navigationItem.rightBarButtonItems = @[toggleMapButton, addLocationButton];

    self.listView = [[ListViewController alloc] init];
    self.mapViewController = [[MapViewController alloc] init];
    self.mapViewController.view.frame = [[UIScreen mainScreen] bounds];
    [self.view addSubview:self.mapViewController.view];

    self.centerMapButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.centerMapButton.frame = CGRectMake(20, 330, 40, 40);
    [self.centerMapButton addTarget:self action:@selector(centerMap) forControlEvents:UIControlEventTouchUpInside];
    [self.mapViewController.view addSubview:self.centerMapButton];

    [self.mapViewController focusCurrentLocationWithDistance:500.0];
    self.mapShowing = YES;
}

- (void)addLocation {
    if (self.mapShowing) {
        ExploreViewController *exploreViewController = [[ExploreViewController alloc] init];
        [self.navigationController pushViewController:exploreViewController animated:YES];
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

- (void)centerMap {
    [self.mapViewController focusCurrentLocationWithDistance:500.0];
}

- (void)setActiveList:(List *)list {
    self.currentList = list;
}

@end
