#import "RNKeyboard.h"

#import <React/RCTView.h>
#import <React/UIView+React.h>

#import <React/RCTBridge.h>


NS_ASSUME_NONNULL_BEGIN

@interface RNPickerKeyboard : RCTView

@property (nonatomic, assign) RCTBridge *bridge;
@property (nonatomic, retain) NSMutableArray<NSDictionary *> *selectedComponents;
@property (nonatomic, retain) RNKeyboard *textInputView;


@property (nonatomic, assign) NSString *placeholder;

@property (nonatomic, assign) NSString *dateStyle;

@property (nonatomic, retain) NSArray *selectedValue;

@property (nonatomic, assign) BOOL showClearButton;

@property (nonatomic, assign) BOOL datePicker;

@property (nonatomic, assign) NSString *seperator;

@property (nonatomic, assign) NSString *dateMode;

@property (nonatomic, assign) BOOL inputAccessoryViewShow;
@property (nonatomic, assign) NSString *inputAccessoryViewID;

@property (nonatomic, copy) RCTBubblingEventBlock onChange;
@property (nonatomic, copy) RCTBubblingEventBlock onPrev;
@property (nonatomic, copy) RCTBubblingEventBlock onNext;

@end

NS_ASSUME_NONNULL_END
