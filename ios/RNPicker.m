#import "RNPicker.h"

#import <React/RCTConvert.h>
#import <React/RCTUtils.h>


@interface RNPicker() <UIPickerViewDataSource, UIPickerViewDelegate>
@end

@implementation RNPicker

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        _componentCount = 1;
        self.delegate = self;
        self.dataSource = self;
        [self selectRow:0 inComponent:0 animated:YES];
    }
    return self;
}

- (void)setItems:(NSArray<NSDictionary *> *)items
{
    _items = [items copy];
    [self setNeedsLayout];
}

- (void)setIndex:(NSInteger)selectedIndex forComponent:(NSInteger)component
{
//    dispatch_async(dispatch_get_main_queue(), ^{
        [self selectRow:selectedIndex inComponent:component animated:YES];
//    });
}

#pragma mark - UIPickerViewDataSource protocol
// set the amount of columns in the picker
- (NSInteger)numberOfComponentsInPickerView:(__unused UIPickerView *)pickerView
{
    return _componentCount;
}
// set the amount of items in the list
- (NSInteger)pickerView:(__unused UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
  return _items[component].count;
}

#pragma mark - UIPickerViewDelegate methods
// determine what value to show in the list
- (NSString *)pickerView:(__unused UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    
    return [RCTConvert NSString:_items[component][row][@"label"]];
}
// determine the height of the selected option
- (CGFloat)pickerView:(__unused UIPickerView *)pickerView rowHeightForComponent:(__unused NSInteger)component
{
    return UIFont.labelFontSize + 25;
}
// handle what to do when a new value is selected
- (void)pickerView:(__unused UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSDictionary *newOption = @{@"selectedIndex":@(row), @"selectedComponent":[NSNumber numberWithInteger:component], @"label":_items[component][row][@"label"], @"value":_items[component][row][@"value"]};
    
    NSLog(@"NEW OPTION: %@", newOption);
    
    _selectedOption = newOption;
    
    // send a notification that the UIPickerView has a new value
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UIPickerViewItemChangeNotification" object:self];
}

@end
