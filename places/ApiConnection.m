#import "ApiConnection.h"

NSString *const kApiUrl = @"https://api.foursquare.com/v2/venues/search?";
NSString *const koauth_token = @"&oauth_token=TCHGP2PM3JLY5GVM4IDV3DSEC3TKLEMRQKYOW32WLYTADZCB&v=20130307";
@implementation ApiConnection

+ (NSArray *)fetchLocations:(NSString *)location {

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@ll=%@%@",kApiUrl, location, koauth_token]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    NSError *requestError;
    NSURLResponse *urlResponse;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&requestError];
    NSDictionary *response = [jsonDictionary objectForKey:@"response"];
    NSArray *venues = [response objectForKey:@"venues"];

    return venues;
}
@end
