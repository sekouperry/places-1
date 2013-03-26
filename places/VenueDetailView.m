#import "VenueDetailView.h"

const NSInteger kEdgeInset = 10;

@implementation VenueDetailView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 180)];
        _imageView.backgroundColor = [UIColor lightGrayColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;

        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_imageView.frame) + kEdgeInset, CGRectGetMaxY(_imageView.frame)+ kEdgeInset, CGRectGetWidth(self.frame)- kEdgeInset*2, 20)];
        _nameLabel.font = [UIFont boldSystemFontOfSize:16];
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(kEdgeInset, CGRectGetMaxY(_nameLabel.frame), CGRectGetWidth(self.frame)-kEdgeInset*2, 20)];
        _addressLabel.font = [UIFont boldSystemFontOfSize:14];
        _addressLabel.textColor = [UIColor lightGrayColor];


        _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_addressLabel.frame) + kEdgeInset, CGRectGetWidth(self.frame), 100)];


        _middleSection = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_mapView.frame), CGRectGetWidth(self.frame), 105)];
        _middleSection.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0  blue:241/255.0  alpha:1.0];
        _openingHoursHeader = [[UILabel alloc] initWithFrame:CGRectMake(kEdgeInset, kEdgeInset, CGRectGetWidth(_middleSection.frame)-kEdgeInset, 20)];
        _openingHoursHeader.text = @"Opening Hours:";
        _openingHoursHeader.font = [UIFont boldSystemFontOfSize:16];
        _openingHoursHeader.textColor = [UIColor darkGrayColor];
        _openingHoursHeader.backgroundColor = [UIColor clearColor];
        _openingHoursLabel = [[UILabel alloc] initWithFrame:CGRectMake(kEdgeInset, CGRectGetMaxY(_openingHoursHeader.frame), CGRectGetWidth(_middleSection.frame)-kEdgeInset, 60)];
        _openingHoursLabel.textColor = [UIColor lightGrayColor];
        _openingHoursLabel.font = [UIFont boldSystemFontOfSize:14];
        _openingHoursLabel.backgroundColor = [UIColor clearColor];
        [_middleSection addSubview:_openingHoursLabel];
        [_middleSection addSubview:_openingHoursHeader];

        _bottomSection = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_middleSection.frame), CGRectGetWidth(self.frame), 60)];
        _bottomSection.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0  blue:241/255.0  alpha:1.0];

        _addToListButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addToListButton setBackgroundImage:[UIImage imageNamed:@"addToList"] forState:UIControlStateNormal];
        _addToListButton.frame = CGRectMake(kEdgeInset, kEdgeInset, CGRectGetWidth(_bottomSection.frame)-kEdgeInset*2, 42);
        _addToListButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        _addToListButton.titleLabel.shadowColor = [UIColor darkGrayColor];
        _addToListButton.titleLabel.shadowOffset = CGSizeMake(-1, 1);
        [_addToListButton setTitle:@"Add to list." forState:UIControlStateNormal];
        [_bottomSection addSubview:_addToListButton];

        [self addSubview:_middleSection];
        [self addSubview:_bottomSection];
        [self addSubview:_mapView];
        [self addSubview:_imageView];
        [self addSubview:_nameLabel];
        [self addSubview:_addressLabel];
    }
    return self;
}

@end
