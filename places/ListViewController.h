#import <UIKit/UIKit.h>
#import "List.h"

@interface ListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) List *currentList;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
