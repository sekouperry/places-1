#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Venue.h"

@interface MapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) Venue *venue;

@end
