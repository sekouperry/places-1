#import <UIKit/UIKit.h>
#import "Venue.h"
#import "VenueDetailView.h"

@interface VenueDetailViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) Venue *venue;
@property (strong, nonatomic) VenueDetailView *detailView;
@property (strong, nonatomic) NSDictionary *venuePhotoDetails;

- (id)initWithVenue:(Venue *)venue;

@end
