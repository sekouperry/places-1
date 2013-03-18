#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface LeftPanelController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSIndexPath *editingCellIndex;
@property (strong, nonatomic) UITextField *editingCellTextField;

@end
