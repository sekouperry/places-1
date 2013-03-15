#import "VenueDetailViewController.h"
#import "VenueDetailView.h"
#import "ApiConnection.h"

static const NSString *kPhotoSize = @"width500";

@implementation VenueDetailViewController

- (id)initWithVenue:(Venue *)venue {
    self = [super init];
    self.venue = venue;
    self.view.backgroundColor = [UIColor whiteColor];
    _detailView = [[VenueDetailView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _detailView.nameLabel.numberOfLines = 2;
    _detailView.nameLabel.text = [NSString stringWithFormat:@"%@\n %@", venue.name, venue.address];
    [self.view addSubview:_detailView];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    void (^completionBlock)(NSDictionary *) = ^(NSDictionary *photo){
        self.venuePhotoDetails = photo;
        [self displayImage];
        
    };
    [ApiConnection fetchPhotosFromVenue:self.venue.foursquareId completionHandler:completionBlock];
}

- (void)displayImage {
    NSString *photoURL = [NSString stringWithFormat:@"%@%@%@", [self.venuePhotoDetails objectForKey:@"prefix"], kPhotoSize, [self.venuePhotoDetails objectForKey:@"suffix"]];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:photoURL]]];
    _detailView.imageView.image = image;
}

@end
