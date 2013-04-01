#import "MapAnnotationView.h"
#import "MapAnnotation.h"
#import <CoreGraphics/CoreGraphics.h>

const NSInteger kFrameSize = 35;
@implementation MapAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];

    if (self != nil) {

        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, kFrameSize+10, kFrameSize+10);
        self.backgroundColor = [UIColor clearColor];
        self.centerOffset = CGPointMake(0, -kFrameSize / 2);
        self.imageView = [[UIImageView alloc] init];
        self.imageView.frame = CGRectMake(0, 0, kFrameSize + 5, kFrameSize + 5);
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)setAnnotation:(id<MKAnnotation>)annotation {
    [super setAnnotation:annotation];
    [self setNeedsDisplay];
}

- (void)createAnnotationPath:(CGMutablePathRef)path {
        float inset = 5.0;
        float halfInset = inset / 2.0;
        CGPathMoveToPoint(path, NULL, inset, inset);
        CGPathAddLineToPoint(path, NULL, kFrameSize, inset);
        CGPathAddLineToPoint(path, NULL, kFrameSize, kFrameSize);

        //Create button triangle
        // Half inset is needed because we offset the icon frame by `inset` so that the line
        // isn't clipped by frame bounds.
        CGPathAddLineToPoint(path, NULL, (kFrameSize/2) + (kFrameSize/4) + halfInset, kFrameSize);
        CGPathAddLineToPoint(path, NULL, (kFrameSize/2) + halfInset, kFrameSize + 6);
        CGPathAddLineToPoint(path, NULL, (kFrameSize/2)-(kFrameSize/4) + halfInset, kFrameSize);
        CGPathAddLineToPoint(path, NULL, inset, kFrameSize);
}

- (void)drawRect:(CGRect)rect {
    MapAnnotation *annotation = (MapAnnotation *)self.annotation;
    if (annotation != nil) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        CGMutablePathRef path = CGPathCreateMutable();
        [self createAnnotationPath:path];

        CGContextAddPath(context, path);
        CGContextClip(context);

        //Create gradient
        UIColor *lightBlue = [UIColor colorWithRed:181.0/255 green:193.0/255 blue:255.0/255 alpha:1.0];
        UIColor *darkBlue = [UIColor colorWithRed:42.0/255 green:65.0/255 blue:163.0/255 alpha:1.0];

        CGColorRef colorRef[] = { [lightBlue CGColor], [darkBlue CGColor] };
        CFArrayRef colors = CFArrayCreate(NULL, (const void**)colorRef, sizeof(colorRef) / sizeof(CGColorRef), &kCFTypeArrayCallBacks);

        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, colors, NULL);
        CFRelease(colorSpace);
        CFRelease(colors);

        CGPoint start = CGPointMake(0, 0);
        CGPoint end = CGPointMake(0, kFrameSize+10);
        CGContextDrawLinearGradient(context, gradient, start, end, 0);
        CFRelease(gradient);

        //Create stroke path
        CGContextAddPath(context, path);
        CGContextClosePath(context);
        CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
        CGContextSetLineWidth(context, 3);
        CGContextStrokePath(context);
        CGContextSetShadowWithColor(context, CGSizeMake(-5, 2), 0, [[UIColor blackColor] CGColor]);

        CGContextRestoreGState(context);
    }
}

@end
