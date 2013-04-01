#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MapViewController.h"
#import "List.h"
#import "ExploreView.h"

@interface ExploreViewController : UIViewController <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate>


@property (strong, nonatomic) ExploreView *exploreView;
@property (strong, nonatomic) NSMutableArray *places;
@property (strong, nonatomic) List *currentList;

@end
