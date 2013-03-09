#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManager : CLLocationManager

+ (id)sharedLocation;

@end
