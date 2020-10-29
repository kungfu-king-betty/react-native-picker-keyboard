#import "RNPickerKeyboardManager.h"
#import "RNPickerKeyboard.h"

@implementation RNPickerKeyboardManager

RCT_EXPORT_MODULE()

- (UIView *)view
{
  return [[RNPickerKeyboard alloc] initWithBridge:self.bridge];
}

@end
