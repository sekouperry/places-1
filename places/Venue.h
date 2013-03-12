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
@property (strong, nonatomic) NSString *foursquareId;
@property (strong, nonatomic) NSDictionary *location;
@property (strong, nonatomic) NSString *foursquareUrl;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSString *openingHours;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *iconUrl;


@end
