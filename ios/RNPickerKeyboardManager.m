#import <React/RCTBridge.h>
#import <React/RCTUIManager.h>
#import <React/RCTUIManagerUtils.h>
#import <React/RCTUIManagerObserverCoordinator.h>

#import "RNPickerKeyboardManager.h"
#import "RNPickerKeyboard.h"


@implementation RNPickerKeyboardManager

RCT_EXPORT_MODULE()

- (UIView *)view
{
    RNPickerKeyboard *pickerKeyboard = [RNPickerKeyboard new];
    [pickerKeyboard setBridge:self.bridge];
    
    _rnPickerKeyboard = pickerKeyboard;
    
    return pickerKeyboard;
}

RCT_EXPORT_VIEW_PROPERTY(placeholder, NSString*)

RCT_EXPORT_VIEW_PROPERTY(dateStyle, NSString*)

RCT_EXPORT_VIEW_PROPERTY(textAlign, NSString*)

RCT_EXPORT_VIEW_PROPERTY(selectedValue, NSArray)

RCT_EXPORT_VIEW_PROPERTY(componentCount, NSInteger)

RCT_EXPORT_VIEW_PROPERTY(showClearButton, BOOL)

RCT_EXPORT_VIEW_PROPERTY(datePicker, BOOL)

RCT_EXPORT_VIEW_PROPERTY(seperator, NSString*)

RCT_EXPORT_VIEW_PROPERTY(dateMode, NSString*)

RCT_EXPORT_VIEW_PROPERTY(onChange, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onPrev, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onNext, RCTBubblingEventBlock)

RCT_EXPORT_VIEW_PROPERTY(items, NSArray<NSDictionary *>)

RCT_EXPORT_VIEW_PROPERTY(inputAccessoryViewShow, BOOL)
RCT_EXPORT_VIEW_PROPERTY(inputAccessoryViewID, NSString)

@end
