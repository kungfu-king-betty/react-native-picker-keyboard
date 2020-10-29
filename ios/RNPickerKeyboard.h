#import <UIKit/UIKit.h>

#import <React/RCTBackedTextInputViewProtocol.h>
#import <React/RCTBackedTextInputDelegate.h>

NS_ASSUME_NONNULL_BEGIN

@interface RNPickerKeyboard : UITextField <RCTBackedTextInputViewProtocol>

- (instancetype)initWithCoder:(NSCoder *)decoder NS_UNAVAILABLE;

@property (nonatomic, weak) id<RCTBackedTextInputDelegate> textInputDelegate;

@property (nonatomic, assign) BOOL caretHidden;
@property (nonatomic, assign) BOOL contextMenuHidden;
@property (nonatomic, assign, readonly) BOOL textWasPasted;
@property (nonatomic, strong, nullable) UIColor *placeholderColor;
@property (nonatomic, assign) UIEdgeInsets textContainerInset;
@property (nonatomic, assign, getter=isEditable) BOOL editable;
@property (nonatomic, getter=isScrollEnabled) BOOL scrollEnabled;

@end

NS_ASSUME_NONNULL_END
