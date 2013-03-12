#import <UIKit/UIKit.h>
#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ExploreViewController : UIViewController <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) MapViewController *mapViewController;

@property (strong, nonatomic) UIButton *hideTableButton;
@property (strong, nonatomic) UIButton *showTableButton;

@property (nonatomic) CGRect originalMapRect;
@property (nonatomic) CGRect originalTableRect;

@property (strong, nonatomic) NSMutableArray *places;

@end
