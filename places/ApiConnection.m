#import <CoreLocation/CoreLocation.h>
#import "Venue.h"
#import "ApiConnection.h"

NSString *const kApiUrl = @"https://api.foursquare.com/v2/venues/search?";
NSString *const koauth_token = @"&oauth_token=TCHGP2PM3JLY5GVM4IDV3DSEC3TKLEMRQKYOW32WLYTADZCB&v=20130307";
@implementation ApiConnection

- (id) init {
    self = [super init];
    return  self;
}

+ (void)fetchVenueswithLocation:(CLLocationCoordinate2D)location Query:(NSString *)query andCompletionHandler:(void (^)())completion {

    NSString *locationParams = [NSString stringWithFormat:@"%f,%f", location.latitude, location.longitude];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@ll=%@&query=%@%@",kApiUrl, locationParams, query,koauth_token]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    [NSURLConnection connectionWithRequest:request delegate:self];

   [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {

       NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
       NSDictionary *responseDictionary = [jsonDictionary objectForKey:@"response"];
       NSArray *venuesResponse = [responseDictionary objectForKey:@"venues"];

       NSMutableArray *venues = [[NSMutableArray alloc] init];
       for (NSDictionary *location in venuesResponse) {
           Venue *venue = [[Venue alloc] init];
           venue.name = [location objectForKey:@"name"];
           venue.location = [location objectForKey:@"location"];
           [venues addObject:venue];
       }
       completion(venues);
   }];

}

+ (void)fetchVenuesFromLocation:(CLLocationCoordinate2D)location completionHandler:(void (^)())completion {

    NSString *locationParams = [NSString stringWithFormat:@"%f,%f", location.latitude, location.longitude];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@ll=%@%@",kApiUrl, locationParams, koauth_token]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    [NSURLConnection connectionWithRequest:request delegate:self];

   [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {

       NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
       NSDictionary *responseDictionary = [jsonDictionary objectForKey:@"response"];
       NSArray *venuesResponse = [responseDictionary objectForKey:@"venues"];

       NSMutableArray *venues = [[NSMutableArray alloc] init];
       for (NSDictionary *location in venuesResponse) {
           Venue *venue = [[Venue alloc] init];
           venue.name = [location objectForKey:@"name"];
           venue.location = [location objectForKey:@"location"];
           [venues addObject:venue];
       }
       completion(venues);
   }];
}
@end
