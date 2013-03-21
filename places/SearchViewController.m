#import "LocationManager.h"
#import "ApiConnection.h"
#import "Venue.h"
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

    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, kToolBarHeight, CGRectGetWidth(self.view.frame), kToolBarHeight)];
    self.searchBar.delegate = self;

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kToolBarHeight*2, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.hideKeyboardButton = [[UIButton alloc] initWithFrame:CGRectMake(0, kToolBarHeight, CGRectGetWidth(self.view.frame), 200)];
    [self.hideKeyboardButton addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventTouchDown];

    [self.view addSubview:self.tableView];
    [self.view addSubview:self.hideKeyboardButton];
    [self.view addSubview:self.searchBar];
    [self.view addSubview:toolbar];
}

- (void)cancel {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"SearchCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [[self.places objectAtIndex:indexPath.row] name];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.places count];
}

#pragma mark UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];

   void(^completionBlock)(NSArray *) = ^(NSArray *array){
       self.places = array;
       dispatch_async(dispatch_get_main_queue(), ^{
           [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
       });
   };

    CLLocationCoordinate2D location = [[[LocationManager sharedLocation] location] coordinate];
    [ApiConnection fetchVenueswithLocation:location Query:searchBar.text andCompletionHandler:completionBlock];
}

- (void)hideKeyboard {
    [self.searchBar resignFirstResponder];
}

@end
