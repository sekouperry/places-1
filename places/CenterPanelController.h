#import <UIKit/UIKit.h>
#import "MapViewController.h"
#import "ListViewController.h"

@interface CenterPanelController : UIViewController

@property (strong, nonatomic) MapViewController *mapView;
@property (strong, nonatomic) ListViewController *listView;
@property (nonatomic) BOOL mapShowing;

@end
