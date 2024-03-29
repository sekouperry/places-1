#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "List.h"

@interface SearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UIButton *hideKeyboardButton;
@property (strong, nonatomic) NSArray *places;
@property (strong, nonatomic) List *currentList;

@end
