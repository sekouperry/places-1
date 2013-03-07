#import "CenterPanelController.h"
#import "ListViewController.h"

@interface CenterPanelController ()

@end

@implementation CenterPanelController

- (id)init {
    self = [super init];

    self.view.frame = [UIScreen mainScreen].bounds;
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(toggleMap:)];
    self.navigationItem.rightBarButtonItem = rightBarButton;

    self.listView = [[ListViewController alloc] init];
    self.mapView = [[MapViewController alloc] init];
    [self.view addSubview:self.mapView.view];
    [self.mapView focusOnLocationWithDistance:500.0];
    self.mapShowing = YES;

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
