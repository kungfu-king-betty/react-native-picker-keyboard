#import "RNPickerKeyboard.h"

@implementation RNPickerKeyboard

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    UITextField* textF = [[UITextField alloc] initWithFrame:frame];

    [self addSubview:textF];

    return self;
}

@end
