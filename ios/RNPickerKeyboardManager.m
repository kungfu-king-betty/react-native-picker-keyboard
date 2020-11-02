#import <React/RCTBridge.h>

#import "RNPickerKeyboardManager.h"
#import "RNPickerKeyboard.h"


@implementation RNPickerKeyboardManager

RCT_EXPORT_MODULE()

- (UIView *)view
{
    return [RNPickerKeyboard new];
}

RCT_EXPORT_VIEW_PROPERTY(textAlign, NSString*)

RCT_EXPORT_VIEW_PROPERTY(componentCount, NSInteger);

RCT_EXPORT_VIEW_PROPERTY(placeholder, NSString*)
RCT_EXPORT_VIEW_PROPERTY(seperator, NSString*)

RCT_EXPORT_VIEW_PROPERTY(items, NSArray<NSDictionary *>)
RCT_EXPORT_VIEW_PROPERTY(selectedIndex, NSArray<NSNumber *>)

RCT_EXPORT_VIEW_PROPERTY(onChange, RCTBubblingEventBlock)

@end
