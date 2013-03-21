#import "MapViewController.h"
#import "List.h"
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ExploreViewController : UIViewController <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) MapViewController *mapViewController;

@property (strong, nonatomic) UIButton *hideTableButton;
@property (strong, nonatomic) UIButton *showTableButton;
@property (strong, nonatomic) UIButton *searchAreaButton;

@property (nonatomic) CGRect originalMapRect;
@property (nonatomic) CGRect originalTableRect;

@property (strong, nonatomic) NSMutableArray *places;
@property (strong, nonatomic) List *currentList;

@end
