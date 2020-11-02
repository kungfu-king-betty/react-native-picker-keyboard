#import <UIKit/UIKit.h>


@interface RNPicker : UIPickerView

@property (nonatomic, assign) NSUInteger componentCount;

@property (nonatomic, assign) NSDictionary *selectedOption;

@property (nonatomic, copy) NSArray<NSArray<NSDictionary *> *> *items;

- (void)setIndex:(NSInteger)selectedIndex forComponent:(NSInteger)component;

@end
