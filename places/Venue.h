#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Venue : NSManagedObject

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

@property (strong, nonatomic) NSSet *lists;

@end
