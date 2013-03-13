#import "VenueDetailViewController.h"
#import "VenueDetailView.h"

@implementation VenueDetailViewController


- (id)init {
    self = [super init];
    self.view = [[VenueDetailView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = [UIColor whiteColor];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 }

@end
