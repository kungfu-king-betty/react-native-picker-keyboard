#import "RNPickerKeyboardViewManager.h"

#import <React/RCTBaseTextInputShadowView.h>
#import "RNPickerKeyboardView.h"

@implementation RNPickerKeyboardViewManager

RCT_EXPORT_MODULE()

- (RCTShadowView *)shadowView
{
  RCTBaseTextInputShadowView *shadowView =
    (RCTBaseTextInputShadowView *)[super shadowView];

  shadowView.maximumNumberOfLines = 1;

  return shadowView;
}

- (UIView *)view
{
  return [[RNPickerKeyboardView alloc] initWithBridge:self.bridge];
}

@end
