#import <CoreLocation/CoreLocation.h>
#import "Venue.h"
#import "ApiConnection.h"
#import "Storage.h"

NSString *const kPhotoApiPrefix = @"https://api.foursquare.com/v2/venues/";
NSString *const kApiUrl = @"https://api.foursquare.com/v2/venues/search?";
NSString *const koauth_token = @"&oauth_token=TCHGP2PM3JLY5GVM4IDV3DSEC3TKLEMRQKYOW32WLYTADZCB&v=20130307";
@implementation ApiConnection

- (id) init {
    self = [super init];
    return  self;
}

+ (void)fetchVenueswithLocation:(CLLocationCoordinate2D)location Query:(NSString *)query andCompletionHandler:(void (^)())completion {
    NSString *locationParams = [NSString stringWithFormat:@"%f,%f", location.latitude, location.longitude];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@ll=%@&query=%@%@",kApiUrl, locationParams, query, koauth_token]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
   [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
       if (error) {
           NSLog(@"Error fetching venue location %@", error.userInfo);
       }

       NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
       NSDictionary *responseDictionary = [jsonDictionary objectForKey:@"response"];
       NSArray *venuesResponse = [responseDictionary objectForKey:@"venues"];

       NSMutableArray *venues = [[NSMutableArray alloc] init];
       for (NSDictionary *location in venuesResponse) {
           NSEntityDescription *venueEntity = [NSEntityDescription entityForName:@"Venue" inManagedObjectContext:[[Storage sharedStorage] managedObjectContext]];

           Venue *venue = [[Venue alloc] initWithEntity:venueEntity insertIntoManagedObjectContext:nil];
           
           venue.name = [location objectForKey:@"name"];
           venue.foursquareId = [location objectForKey:@"id"];

           NSDictionary *contactDictionary = [location objectForKey:@"contact"];
           venue.phoneNumber = [contactDictionary objectForKey:@"formattedPhone"];

           NSDictionary *locationDictionary = [location objectForKey:@"location"];
           venue.address = [locationDictionary objectForKey:@"address"];
           venue.lat = [[locationDictionary objectForKey:@"lat"] stringValue];
           venue.lng = [[locationDictionary objectForKey:@"lng"] stringValue];
           venue.city = [locationDictionary objectForKey:@"city"];
           venue.state = [locationDictionary objectForKey:@"state"];
           venue.country = [locationDictionary objectForKey:@"country"];

           NSArray *categoryDictionary = [location objectForKey:@"categories"];
           if ([categoryDictionary count] >= 1) {
               NSDictionary *iconDictionary = [[categoryDictionary objectAtIndex:0] objectForKey:@"icon"];
               [venue setIconUrl:[iconDictionary objectForKey:@"prefix"]];
           }

           [venues addObject:venue];
       }
       completion(venues);
       [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
   }];
}

+ (void)fetchVenuesFromLocation:(CLLocationCoordinate2D)location completionHandler:(void (^)())completion {
    [self fetchVenueswithLocation:location Query:@"" andCompletionHandler:completion];
}

+ (void)fetchPhotosFromVenue:(NSString *)venueId completionHandler:(void (^)())completion {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?%@", kPhotoApiPrefix, venueId, koauth_token]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

        NSDictionary *responseDictionary = [jsonResponse objectForKey:@"response"];
        NSDictionary *venueDictionary = [responseDictionary objectForKey:@"venue"];
        NSDictionary *photoDictionary = [venueDictionary objectForKey:@"photos"];
        NSDictionary *firstImageDictionary = [[[[photoDictionary objectForKey:@"groups"] lastObject] objectForKey:@"items"] firstObject];
        completion(firstImageDictionary);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}

@end
