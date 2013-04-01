#import "LocationManager.h"
#import "ApiConnection.h"
#import "Venue.h"
#import "SearchViewController.h"
#import "VenueDetailViewController.h"

@interface SearchViewController ()

@end

const NSInteger kSearchBarHeight = 40;
@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), kSearchBarHeight)];
    [self.searchBar setBarStyle:UIBarStyleBlack];
    self.searchBar.delegate = self;

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kSearchBarHeight, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.hideKeyboardButton = [[UIButton alloc] initWithFrame:CGRectMake(0, kSearchBarHeight, CGRectGetWidth(self.view.frame), 200)];
    [self.hideKeyboardButton addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventTouchDown];

    [self.view addSubview:self.tableView];
    [self.view addSubview:self.searchBar];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self showDetailViewControllerWithVenue:[self.places objectAtIndex:indexPath.row]];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (!self.places) {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 20)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(header.frame)/2)-70, CGRectGetHeight(header.frame)/2, CGRectGetWidth(tableView.frame), 20)];
        label.text = @"No results found.";
        label.textColor= [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0  alpha:1.0];
        label.font = [UIFont boldSystemFontOfSize:16];
        [header addSubview:label];
        return header;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (!self.places) {
        return 20.0;
    }
    return 0.0;
}

- (void)showDetailViewControllerWithVenue:(Venue *)venue {
    VenueDetailViewController *detailViewController = [[VenueDetailViewController alloc] initWithVenue:venue];
    detailViewController.currentList = self.currentList;
    detailViewController.title = venue.name;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.view addSubview:self.hideKeyboardButton];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self hideKeyboard];

    CLLocationCoordinate2D location = [[[LocationManager sharedLocation] location] coordinate];
    [ApiConnection fetchVenueswithLocation:location Query:searchBar.text andCompletionHandler:^(NSArray *array) {
        self.places = array;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        });
    }];
}

- (void)hideKeyboard {
    [self.hideKeyboardButton removeFromSuperview];
    [self.searchBar resignFirstResponder];
}

@end
