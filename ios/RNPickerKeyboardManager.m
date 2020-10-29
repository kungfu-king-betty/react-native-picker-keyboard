#import "RNPickerKeyboardManager.h"

@implementation RNPickerKeyboardManager

RCT_EXPORT_MODULE(RNPickerKeyboard)

- (UIView *)view
{
  return [[MKMapView alloc] init];
}

@end
