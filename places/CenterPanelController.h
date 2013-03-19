#import <UIKit/UIKit.h>
#import "MapViewController.h"
#import "ListViewController.h"
#import "List.h"
#import "LeftPanelController.h"

@interface CenterPanelController : UIViewController <LeftPanelDelegate, MKMapViewDelegate>

@property (strong, nonatomic) MapViewController *mapViewController;
@property (strong, nonatomic) ListViewController *listView;
@property (strong, nonatomic) UIButton *centerMapButton;
@property (strong, nonatomic) List *currentList;
@property (nonatomic) BOOL mapShowing;

@end
