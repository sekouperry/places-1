#import <Foundation/Foundation.h>

@interface ApiConnection : NSObject

+ (void)fetchVenuesFromLocation:(NSString *)location completionHandler:(void(^)())completion;

@property (strong, nonatomic) NSURLConnection *urlConnection;

@end
