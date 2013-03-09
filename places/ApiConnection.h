#import <Foundation/Foundation.h>

@interface ApiConnection : NSObject

+ (void)fetchVenuesFromLocation:(NSString *)location completionHandler:(void(^)())completion;
+ (void)venuesWithLocation:(NSString *)location andSearchTerm:(NSString *)term completion:(void (^)())completion;

@property (strong, nonatomic) NSURLConnection *urlConnection;

@end
