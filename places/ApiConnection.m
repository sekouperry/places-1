#import "ApiConnection.h"
#import "Venue.h"

NSString *const kApiUrl = @"https://api.foursquare.com/v2/venues/search?";
NSString *const koauth_token = @"&oauth_token=TCHGP2PM3JLY5GVM4IDV3DSEC3TKLEMRQKYOW32WLYTADZCB&v=20130307";
@implementation ApiConnection

- (id) init {
    self = [super init];
    return  self;
}

+ (void)fetchVenuesFromLocation:(NSString *)location completionHandler:(void (^)())completion {

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@ll=%@%@",kApiUrl, location, koauth_token]];
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

+ (void)venuesWithLocation:(NSString *)location andSearchTerm:(NSString *)term completion:(void (^)())completion {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@ll=%@&query=%@%@",kApiUrl, location, term, koauth_token]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    [NSURLConnection connectionWithRequest:request delegate:self];

   [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {

       NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
       NSLog(@"%@", jsonDictionary);
       NSDictionary *responseDictionary = [jsonDictionary objectForKey:@"response"];
       NSArray *venuesResponse = [responseDictionary objectForKey:@"venues"];
       NSLog(@"%@", responseDictionary);

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
