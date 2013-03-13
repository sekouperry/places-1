#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Venue : NSManagedObjectModel

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

@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *lat;
@property (strong, nonatomic) NSString *lng;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *country;

@property (strong, nonatomic) NSString *foursquareUrl;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSString *iconUrl;


@end
