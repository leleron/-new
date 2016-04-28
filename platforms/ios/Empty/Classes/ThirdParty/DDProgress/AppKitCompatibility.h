#define UIView NSView
#define UIColor NSColor
#define UIGraphicsGetCurrentContext() [[NSGraphicsContext currentContext] graphicsPort]

@interface UIView (UIKit)

@property (nonatomic) UIColor *backgroundColor ;

- (void)setNeedsDisplay ;

@end
