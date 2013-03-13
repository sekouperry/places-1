#import <UIKit/UIKit.h>
#import "Venue.h"
#import "VenueDetailView.h"

@interface VenueDetailViewController : UIViewController

@property (strong, nonatomic) Venue *venue;
@property (strong, nonatomic) VenueDetailView *detailView;

- (id)initWithVenue:(Venue *)venue;

@end
