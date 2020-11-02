#import <React/RCTView.h>
#import <React/UIView+React.h>


NS_ASSUME_NONNULL_BEGIN

@interface RNPickerKeyboard : RCTView

@property (nonatomic, retain) NSMutableArray<NSDictionary *> *selectedComponents;

@property (nonatomic, assign) NSString *seperator;
@property (nonatomic, retain) NSArray<NSNumber *> *selectedIndex;

@property (nonatomic, copy) RCTBubblingEventBlock onChange;

@end

NS_ASSUME_NONNULL_END
