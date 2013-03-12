#import <UIKit/UIKit.h>
#import "MapViewController.h"
#import "ListViewController.h"

@interface CenterPanelController : UIViewController

@property (strong, nonatomic) MapViewController *mapViewController;
@property (strong, nonatomic) ListViewController *listView;
@property (nonatomic) BOOL mapShowing;
@property (strong, nonatomic) UIButton *centerMapButton;

@end
