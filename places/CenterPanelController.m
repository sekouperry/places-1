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

- (void)viewWillAppear:(BOOL)animated {
    self.mapShowing = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"%@ has %d venues", [self.currentList name], [self.currentList.venues count]);
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.frame = [UIScreen mainScreen].bounds;
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *toggleMapButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(toggleMap:)];
    UIBarButtonItem *addLocationButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(exploreLocations)];
    self.navigationItem.rightBarButtonItems = @[toggleMapButton, addLocationButton];

    [self addObserver:self forKeyPath:@"currentList" options:NSKeyValueObservingOptionNew context:nil];
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
    }
}

@end
