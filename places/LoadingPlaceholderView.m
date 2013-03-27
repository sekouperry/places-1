#import "LoadingPlaceholderView.h"

@implementation LoadingPlaceholderView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(frame)/2) - 100, 100, 200, 20)];
        self.messageLabel.text = @"Finding places...";
        self.messageLabel.backgroundColor = [UIColor clearColor];
        self.messageLabel.font = [UIFont boldSystemFontOfSize:20];
        self.messageLabel.textColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0  alpha:1.0];

        self.refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.refreshButton setBackgroundImage:[UIImage imageNamed:@"refreshButtonImage"] forState:UIControlStateNormal];
        self.refreshButton.frame = CGRectMake(CGRectGetMidX(self.frame)-20, 100, 40, 36);
        self.refreshButton.alpha = 0;
        [self addSubview:self.refreshButton];

        self.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
        [self addSubview:self.messageLabel];
    }
    return self;
}

- (void)swingLabel {
    self.refreshButton.alpha = 0;
    self.messageLabel.text = @"Finding places...";

    [UIView animateWithDuration:1.0 delay:0 options:(UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat) animations:^{
        [self.messageLabel setTransform:CGAffineTransformMakeRotation(M_PI)];
    } completion:^(BOOL finished){
    }];
}

- (void)errorAnimation {
    [UIView animateWithDuration:1.0 delay:0.0 options:(UIViewAnimationOptionBeginFromCurrentState) animations:^{
        [self.messageLabel setTransform:CGAffineTransformMakeTranslation(0, -40)];
        self.refreshButton.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];

}

@end
