#import "AppDelegate.h"
#import "LeftPanelController.h"
#import "CenterPanelController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.viewController = [[JASidePanelController alloc] init];
    self.viewController.leftPanel = [[LeftPanelController alloc] init];
    self.viewController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[[CenterPanelController alloc] init]];

    // Set left panel delegate to center panel to pass the active list.
    [(LeftPanelController *)self.viewController.leftPanel setDelegate:[[(UINavigationController *)self.viewController.centerPanel viewControllers] objectAtIndex:0]];
    UIImage * backButtonImage = [UIImage imageNamed: @"navigationButton"];
    backButtonImage = [backButtonImage stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage: backButtonImage forState:UIControlStateNormal barMetrics: UIBarMetricsDefault];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}
							
@end
