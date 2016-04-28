#import "AppKitCompatibility.h"

@implementation UIView (UIKit)

- (UIColor *)backgroundColor
{
	return nil ;
}

- (void)setBackgroundColor:(UIColor *)color
{
	return ;
}

- (void)setNeedsDisplay
{
	[self setNeedsDisplay:YES] ;
}

@end
