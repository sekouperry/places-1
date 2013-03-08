#import <UIKit/UIKit.h>
#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface SearchViewController : UIViewController <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) MapViewController *mapView;
@property (strong, nonatomic) UIButton *hideTableButton;
@property (strong, nonatomic) UIButton *showTableButton;

@property (nonatomic) CGRect originalMapRect;
@property (nonatomic) CGRect originalTableRect;

@end
