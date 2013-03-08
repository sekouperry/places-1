#import "ListViewController.h"

@interface ListViewController ()

@end

@implementation ListViewController

-(id)init {
    self  = [super init];
    self.view.frame = [[UIScreen mainScreen] bounds];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.tableView];
}

@end
