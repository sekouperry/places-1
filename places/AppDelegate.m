#import "AppDelegate.h"
#import "LeftPanelController.h"
#import "CenterPanelController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.viewController = [[JASidePanelController alloc] init];
    self.viewController.leftPanel = [[LeftPanelController alloc] init];
    self.viewController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[[CenterPanelController alloc] init]];

    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}
							
@end
