#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "List.h"

@protocol LeftPanelDelegate <NSObject>

@required
- (void)setActiveList:(List *)list;

@end

static NSString * const kSelectedList = @"SelectedList";

@interface LeftPanelController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate> {
    id <LeftPanelDelegate> delegate;
}

@property (strong, nonatomic) id delegate;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSIndexPath *editingCellIndex;
@property (strong, nonatomic) UITextField *editingCellTextField;

@end
