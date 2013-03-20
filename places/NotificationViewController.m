#import "NotificationViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface NotificationViewController ()

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSInteger frameWidth = 150;
    self.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - (frameWidth / 2), [UIScreen mainScreen].bounds.size.height / 2 - frameWidth, frameWidth, frameWidth);
    self.view.backgroundColor = [UIColor blackColor];
    self.view.alpha = 0.8;
    self.view.layer.cornerRadius = 8;
    self.view.layer.masksToBounds = YES;

    NSInteger width = 100;
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)/2 - (width / 2), CGRectGetHeight(self.view.frame)/2, 100, 100)];
    self.textLabel.text = self.message;
    self.textLabel.numberOfLines = 2;
    self.textLabel.font = [UIFont boldSystemFontOfSize:14];
    self.textLabel.textAlignment = UITextAlignmentCenter;
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.textLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.textLabel];
}

- (void)viewWillAppear:(BOOL)animated {
    self.textLabel.text = self.message;
}

@end
