#import <CoreData/CoreData.h>

@interface List : NSManagedObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSSet *venues;

@end
