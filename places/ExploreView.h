#import <UIKit/UIKit.h>
#import "MapViewController.h"
#import "LoadingPlaceholderView.h"

@interface ExploreView : UIView

@property (strong, nonatomic) UIButton *hideTableButton;
@property (strong, nonatomic) UIButton *showTableButton;
@property (strong, nonatomic) UIButton *searchAreaButton;
@property (strong, nonatomic) MapViewController *mapViewController;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) LoadingPlaceholderView *loadingPlaceholder;

@property (nonatomic) CGRect originalMapRect;
@property (nonatomic) CGRect originalTableRect;

@end
