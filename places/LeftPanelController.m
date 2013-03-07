#import "LeftPanelController.h"

@interface LeftPanelController ()

@end

@implementation LeftPanelController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (id)init {
    self = [super init];
    self.view.frame = CGRectMake(0, 0, 360, 480);
    self.view.backgroundColor = [UIColor grayColor];
    return self;
}

@end
