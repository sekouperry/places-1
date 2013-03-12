#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) NSString *iconUrl;
@property (strong, nonatomic) NSString *name;

@end
