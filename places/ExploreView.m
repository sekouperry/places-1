#import "ExploreView.h"

@implementation ExploreView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect mapRect;
        CGRect tableRect;
        CGRectDivide(self.bounds, &mapRect, &tableRect, CGRectGetHeight(self.bounds)*0.2, CGRectMinYEdge);
        self.originalMapRect = mapRect;
        self.originalTableRect = tableRect;

        self.hideTableButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.hideTableButton.frame = mapRect;

        self.showTableButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.showTableButton.frame = CGRectMake(20, 20, 36, 36);
        [self.showTableButton setBackgroundImage:[UIImage imageNamed:@"displayTable"] forState:UIControlStateNormal];
        self.showTableButton.hidden = YES;

        self.searchAreaButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.searchAreaButton setBackgroundImage:[UIImage imageNamed:@"searchArea"] forState:UIControlStateNormal];
        self.searchAreaButton.frame = CGRectMake((CGRectGetMaxX(self.frame) / 2) - 100, CGRectGetHeight(self.frame) - 105, 200, 40);
        [self.searchAreaButton setTitle:@"Search this area" forState:UIControlStateNormal];
        [self.searchAreaButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [self.searchAreaButton.titleLabel setShadowColor:[UIColor blackColor]];
        [self.searchAreaButton.titleLabel setShadowOffset:CGSizeMake(-1, 0)];
        self.searchAreaButton.hidden = YES;

        self.mapViewController = [[MapViewController alloc] init];
        self.mapViewController.view.frame = mapRect;
        self.mapViewController.mapView.frame = mapRect;

        self.tableView = [[UITableView alloc] initWithFrame:tableRect];

        self.loadingPlaceholder = [[LoadingPlaceholderView alloc] initWithFrame:self.originalTableRect];

        [self addSubview:self.mapViewController.view];
        [self addSubview:self.loadingPlaceholder];
        [self addSubview:self.hideTableButton];
        [self.mapViewController.view addSubview:self.showTableButton];
        [self.mapViewController.view addSubview:self.searchAreaButton];
    }
    return self;
}

@end
