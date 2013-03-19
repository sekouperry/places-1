#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManager : CLLocationManager <CLLocationManagerDelegate>

+ (id)sharedLocation;

@end
