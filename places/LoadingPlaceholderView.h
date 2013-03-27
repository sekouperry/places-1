#import <UIKit/UIKit.h>

@interface LoadingPlaceholderView : UIView

@property (strong, nonatomic) UILabel *messageLabel;
@property (strong, nonatomic) UIButton *refreshButton;

- (void)errorAnimation;
- (void)swingLabel;

@end
