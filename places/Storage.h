#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@interface Storage : NSObject

+ (Storage *)sharedStorage;
- (NSURL *)applicationDocumentsDirectory;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;

@end
