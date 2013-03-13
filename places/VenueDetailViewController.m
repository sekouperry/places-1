#import "VenueDetailViewController.h"
#import "VenueDetailView.h"

@implementation VenueDetailViewController

- (id)initWithVenue:(Venue *)venue {
    self = [super init];
    self.venue = venue;
    self.view.backgroundColor = [UIColor whiteColor];
    _detailView = [[VenueDetailView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _detailView.openingHoursLabel.text = self.venue.openingHours;
    NSLog(@"%@", venue.name);
    NSLog(@"%@", self.venue.openingHours);
    [self.view addSubview:_detailView];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 }

@end
