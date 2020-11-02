#import "RNKeyboard.h"

#import <React/RCTUtils.h>
#import <React/RCTTextAttributes.h>

#import <QuartzCore/QuartzCore.h>


@interface RNKeyboard() <UITextFieldDelegate>
@end

@implementation RNKeyboard {
  NSDictionary<NSAttributedStringKey, id> *_defaultTextAttributes;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // set the default placeholder value
        self.placeholder = @"Select an option...";
        
        UIView *paddingViewL = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
        self.leftView = paddingViewL;
        self.leftViewMode = UITextFieldViewModeAlways;
        
        UIView *paddingViewR = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
        self.rightView = paddingViewR;
        self.rightViewMode = UITextFieldViewModeAlways;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                              selector:@selector(onKeyboardOpen)
                                              name:UITextFieldTextDidBeginEditingNotification
                                              object:self];
    }

    return self;
}

- (void)onKeyboardOpen
{
    // send a notification that the UIPickerView has a new value
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UITextFieldKeyboardIsOpen" object:self];
}

#pragma mark - Draw Manipulation
- (void)drawRect:(CGRect)rect
{
    CGRect bounds = [self bounds];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat radius = 0.3f * CGRectGetHeight(bounds);
    
    // TEXT INPUT OBJECT
    // create the shape for the outter most input field
    CGMutablePathRef outerPath = CGPathCreateMutable();
    // round the corners
    CGRect innerPath = CGRectInset(bounds, radius, radius);
    // move to the start of the rectangle
    CGPathMoveToPoint(outerPath, NULL, innerPath.origin.x, bounds.origin.y);
    // draw the top line
    CGPathAddLineToPoint(outerPath, NULL, innerPath.origin.x + innerPath.size.width, bounds.origin.y);
    // draw the top right corner
    CGPathAddArcToPoint(outerPath, NULL, bounds.origin.x + bounds.size.width, bounds.origin.y, bounds.origin.x + bounds.size.width, innerPath.origin.y, radius);
    // draw the right side
    CGPathAddLineToPoint(outerPath, NULL, bounds.origin.x + bounds.size.width, innerPath.origin.y + innerPath.size.height);
    // draw the bottom right corner
    CGPathAddArcToPoint(outerPath, NULL,  bounds.origin.x + bounds.size.width, bounds.origin.y + bounds.size.height, innerPath.origin.x + innerPath.size.width, bounds.origin.y + bounds.size.height, radius);
    // draw the bottom line
    CGPathAddLineToPoint(outerPath, NULL, innerPath.origin.x, bounds.origin.y + bounds.size.height);
    // draw the bottom left corner
    CGPathAddArcToPoint(outerPath, NULL,  bounds.origin.x, bounds.origin.y + bounds.size.height, bounds.origin.x, innerPath.origin.y + innerPath.size.height, radius);
    // draw the left side
    CGPathAddLineToPoint(outerPath, NULL, bounds.origin.x, innerPath.origin.y);
    // draw the top left corner
    CGPathAddArcToPoint(outerPath, NULL,  bounds.origin.x, bounds.origin.y, innerPath.origin.x, bounds.origin.y, radius);
    // back to start so close the path
    CGPathCloseSubpath(outerPath);
    // Fill this path
    UIColor *aColor = [UIColor whiteColor];
    [aColor setFill];
    CGContextAddPath(context, outerPath);
    CGContextFillPath(context);
    // Add the visible path as the clipping path to the context
    CGContextAddPath(context, outerPath);
    CGContextClip(context);

    // SHADOW OBJECTS
    // shadow color
    aColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f];
    // create new paths for both the top and bottom shadows
    CGMutablePathRef top_path = CGPathCreateMutable();
    CGMutablePathRef bottom_path = CGPathCreateMutable();
    // inset the previous bounds to create slightly smaller objects
    CGPathAddRect(top_path, NULL, CGRectInset(bounds, -42, -42));
    CGPathAddRect(bottom_path, NULL, CGRectInset(bounds, -42, -42));
    // Add the visible path (so that it gets subtracted for the shadow), then close the paths
    CGPathAddPath(top_path, NULL, outerPath);
    CGPathCloseSubpath(top_path);
    CGPathAddPath(bottom_path, NULL, outerPath);
    CGPathCloseSubpath(bottom_path);
    
    // DRAW TOP SHADOW
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, CGSizeMake(2.0f, 2.0f), 3.0f, [aColor CGColor]);
    [aColor setFill];
    CGContextSaveGState(context);
    CGContextAddPath(context, top_path);
    CGContextEOFillPath(context);

    // DRAW BOTTOM SHADOW
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, CGSizeMake(-2.0f, -2.0f), 3.0f, [aColor CGColor]);
    [aColor setFill];
    CGContextSaveGState(context);
    CGContextAddPath(context, bottom_path);
    CGContextEOFillPath(context);

    // Release all the paths
    CGPathRelease(top_path);
    CGPathRelease(bottom_path);
    CGPathRelease(outerPath);
}

#pragma mark - Caret Manipulation

- (CGRect)caretRectForPosition:(UITextPosition *)position
{
    // hide the caret in the input field
    return CGRectZero;
}

@end
