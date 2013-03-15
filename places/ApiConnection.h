#import <Foundation/Foundation.h>

@interface ApiConnection : NSObject

+ (void)fetchVenuesFromLocation:(CLLocationCoordinate2D)location completionHandler:(void(^)())completion;
+ (void)fetchVenueswithLocation:(CLLocationCoordinate2D)location Query:(NSString *)query andCompletionHandler:(void (^)())completion;
+ (void)fetchPhotosFromVenue:(NSString *)venueId completionHandler:(void(^)())completion;

@property (strong, nonatomic) NSURLConnection *urlConnection;

@end
