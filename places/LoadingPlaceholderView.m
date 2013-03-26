#import "LoadingPlaceholderView.h"

@implementation LoadingPlaceholderView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(frame)/2) - 100, 100, 200, 20)];
        self.messageLabel.text = @"Loading data...";
        self.messageLabel.backgroundColor = [UIColor clearColor];
        self.messageLabel.font = [UIFont boldSystemFontOfSize:20];
        self.messageLabel.textColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0  alpha:1.0];

        self.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
        [self addSubview:self.messageLabel];
        self.shouldAnimate = YES;
        [self swingLabel];
    }
    return self;
}

- (void)swingLabel {
    if (_shouldAnimate) {
        [UIView animateWithDuration:1.0 delay:0 options:(UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse) animations:^{
            [self.messageLabel setTransform:CGAffineTransformMakeRotation(M_PI)];
        } completion:^(BOOL finished){
        }];
    }
}

@end
