#import "VenueDetailView.h"

const NSInteger kEdgeInset = 10;

@implementation VenueDetailView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 100)];
        _imageView.backgroundColor = [UIColor lightGrayColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;

        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_imageView.frame) + kEdgeInset, CGRectGetMaxY(_imageView.frame)+ kEdgeInset, CGRectGetWidth(self.frame)- kEdgeInset*2, 40)];
        _nameLabel.backgroundColor = [UIColor lightGrayColor];

        _addToListButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _addToListButton.frame = CGRectMake(CGRectGetMinX(_nameLabel.frame), CGRectGetMaxY(_nameLabel.frame) + kEdgeInset, 150, 30);
        [_addToListButton setTitle:@"Add to list." forState:UIControlStateNormal];

        _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(kEdgeInset, CGRectGetMaxY(_addToListButton.frame) + kEdgeInset, CGRectGetWidth(_nameLabel.frame), 100)];

        _openingHoursLabel = [[UILabel alloc] initWithFrame:CGRectMake(kEdgeInset, CGRectGetMaxY(_mapView.frame), CGRectGetWidth(_nameLabel.frame), 80)];
        _openingHoursLabel.text = @"Opening Hours:";

        [self addSubview:_openingHoursLabel];
        [self addSubview:_mapView];
        [self addSubview:_addToListButton];
        [self addSubview:_imageView];
        [self addSubview:_nameLabel];
    }
    return self;
}

@end
