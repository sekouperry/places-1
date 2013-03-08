#import <Foundation/Foundation.h>

@interface Venue : NSObject

//location: {
//    address: "110 Wall Street"
//    lat: 40.700150079671246
//    lng: -74.00135297634154
//    distance: 115
//    city: "New York"
//    state: "NY"
//    country: "United States"
//    cc: "US"
//}

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSDictionary *location;

@end
