#import <Foundation/Foundation.h>

@interface ApiConnection : NSObject

+ (void)fetchVenuesFromLocation:(CLLocationCoordinate2D)location completionHandler:(void(^)(NSArray *))completion;
+ (void)fetchVenueswithLocation:(CLLocationCoordinate2D)location Query:(NSString *)query andCompletionHandler:(void (^)(NSArray *))completion;
+ (void)fetchPhotosFromVenue:(NSString *)venueId completionHandler:(void(^)(NSDictionary *))completion;
+ (void)fetchDetailsFromVenue:(NSString *)venueId compeltionHandler:(void (^)(NSDictionary *))completion;

@end
