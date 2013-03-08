#import "SearchViewController.h"

@interface SearchViewController ()

@end

const NSInteger kToolBarHeight = 44;
@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    toolbar.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), kToolBarHeight);

    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    toolbar.items = @[cancelButton];

    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, kToolBarHeight, CGRectGetWidth(self.view.frame), kToolBarHeight)];

    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kToolBarHeight, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];

    [self.view addSubview:tableView];
    [self.view addSubview:searchBar];
    [self.view addSubview:toolbar];
}

- (void)cancel {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark UITableViewDelegate

#pragma mark UISearchBarDelegate

@end
