#import "RNPickerKeyboard.h"

@implementation RNPickerKeyboard

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    UITextField* textF = [[UITextField alloc] initWithFrame:CGRectMake(0,0,200,30)];
    textF.backgroundColor = [UIColor colorWithRed:0.2 green:0.9 blue:0.5 alpha:0.3];

    [self addSubview:textF];

    return self;
}

@end
