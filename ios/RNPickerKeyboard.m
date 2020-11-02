#import "RNPickerKeyboard.h"
#import "RNKeyboard.h"
#import "RNPicker.h"

#import <React/RCTUtils.h>


@implementation RNPickerKeyboard
{
  RNKeyboard* _textInputView;
  RNPicker* _pickerView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // create the RNPicker UIPickerView
        _pickerView = [RNPicker new];
        // create and style the RNKeyboard UITextField
        _textInputView = [[RNKeyboard alloc] initWithFrame:self.bounds];
        _textInputView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _textInputView.inputView = _pickerView;
        
        // create the input accessoty view
        UIToolbar* accessory = [UIToolbar new];
        // create and add the input accessory view buttons
        NSMutableArray* buttons = [[NSMutableArray alloc] init];
        // Prev/Up button first
        UIBarButtonItem* prevButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Previous Arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(onPrevious)];
        [prevButton setEnabled:NO];
        [buttons addObject:prevButton];
        // Next/Down button next
        UIBarButtonItem* nextButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Next Arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(onNext)];
        [nextButton setEnabled:NO];
        [buttons addObject:nextButton];
        // spacer button to have buttons be on left and right sides
        UIBarButtonItem* spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        [buttons addObject:spacer];
        // done button last aka right side
        UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onDone)];
        [buttons addObject:doneButton];
        // set the input accessory buttons and their size description
        [accessory setItems:buttons];
        [accessory sizeToFit];
        // add the input accessory view to the responder
        _textInputView.inputAccessoryView = accessory;
        
        // add a listener for the Picker Value change
        [[NSNotificationCenter defaultCenter] addObserver:self
                                              selector:@selector(onPickerChange)
                                              name:@"UIPickerViewItemChangeNotification"
                                              object:_pickerView];
        // add a listener for when the keybaord opens i.e. the textfield is in focus
        [[NSNotificationCenter defaultCenter] addObserver:self
                                              selector:@selector(onKeyboardDidOpen)
                                              name:@"UITextFieldKeyboardIsOpen"
                                              object:_textInputView];
        // add the textfield to the view
        [self addSubview:_textInputView];
    }

    return self;
}

- (void)setTextAlign:(NSString*)textAlign
{
    if ([textAlign isEqualToString:@"center"] || [textAlign isEqualToString:@"C"]) {
        _textInputView.textAlignment = NSTextAlignmentCenter;
    } else if ([textAlign isEqualToString:@"right"] || [textAlign isEqualToString:@"R"]) {
        _textInputView.textAlignment = NSTextAlignmentRight;
    } else {
        _textInputView.textAlignment = NSTextAlignmentLeft;
    }
}
// function to set the RNKeyboard placeholder
- (void)setPlaceholder:(NSString*)placeholder
{
    _textInputView.placeholder = placeholder;
}

- (void)setComponentCount:(NSUInteger)componentCount
{
    _pickerView.componentCount = componentCount;
    
    _selectedComponents = [NSMutableArray arrayWithCapacity:componentCount];
}
// function to set the items of the RNPicker
- (void)setItems:(NSArray<NSDictionary *> *)items
{
//    NSArray<NSDictionary *>* items_copy;
    // make sure the option list starts with a blank option
//    if (items.count && items[0] && items[0][@"value"] && [items[0][@"value"] length]) {
//        items_copy = [self addBlankOption:items];
//    } else {
//        items_copy = items;
//    }
    
    // initalize the index values to be used in the loop over components
    NSUInteger loopIndex = 0, offsetIndex = 0, endIndex = 0;
    // initalize the arrays to be used in the loop over components
    NSArray<NSArray<NSDictionary *> *> * items_final = [NSArray array];
    NSArray<NSDictionary *> *test_array = [NSArray array];
    // loop through the given items while counting the component columns
    while (loopIndex < _pickerView.componentCount) {
        // start with a copy of the array and exclude any objects already copied
        test_array = [items subarrayWithRange:NSMakeRange(offsetIndex, items.count-offsetIndex)];
        // get the offset index of the current blank start option
        // look for the first option with a blank value for the @value key
        offsetIndex = [test_array indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop){
            NSDictionary *itm = (NSDictionary *)obj;
            return [itm[@"value"] isEqualToString:@""];
        }];
        
//        if (offsetIndex == NSNotFound) {
//             [NSException raise:@"Invalid items array" format:@"Expected %lu blank values for the @value key", (unsigned long)_pickerView.componentCount];
//        }

        // set the end index for the item copy list
        // the end index if the second index of a blank value for the @value key
        endIndex = [test_array indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop){
            NSDictionary *itm = (NSDictionary *)obj;
            if (idx > 0) {
                return [itm[@"value"] isEqualToString:@""];
            } else {
                return NO;
            }
        }];
        // copy the items from the array using the offset and end index values as the range
        NSArray<NSDictionary *> * componentItems = [test_array subarrayWithRange:NSMakeRange(offsetIndex, (endIndex < test_array.count) ? endIndex-offsetIndex : (test_array.count)-offsetIndex)];
        // add the copied array range as its own array to the final array
        items_final = [items_final arrayByAddingObject:componentItems];
        // update the selected component value
        [_selectedComponents setObject:[componentItems objectAtIndex:[_selectedIndex[loopIndex] unsignedIntValue]] atIndexedSubscript:loopIndex];
        // update the offset index to the end index for the next itration to
        // remove the previous objects just copied
        offsetIndex = endIndex;
        // increment the loop index
        loopIndex++;
    }
    // copy the items to the pickerView item list
    _pickerView.items = [items_final copy];
    [self setNeedsLayout];
    
    [self pickerDisplayText];
}

- (NSArray<NSDictionary *> *)addBlankOption:(NSArray<NSDictionary *> *)items
{
    NSArray<NSDictionary *>* items_copy = [NSArray array];
    NSDictionary* blankOption = @{
        @"label" : _textInputView.placeholder,
        @"value" : @""
    };
    items_copy = [items_copy arrayByAddingObject:blankOption];
    items_copy = [items_copy arrayByAddingObjectsFromArray:items];
    
    return items_copy;
}

- (void)onKeyboardDidOpen
{
    NSNumber *tmp_index = 0;
    for (NSNumber *tmp in _selectedIndex) {
        [_pickerView setIndex:[tmp integerValue] forComponent:[tmp_index intValue]];

        tmp_index = [NSNumber numberWithInt:[tmp_index intValue]+1];
    }
}
// handler for when the picker value change notification is called
- (void)onPickerChange
{
    NSDictionary *selectedOption = _pickerView.selectedOption;
    
    // set the select component and index locally
    NSMutableArray* tmp_array = [NSMutableArray arrayWithArray:_selectedIndex];
    [tmp_array setObject:selectedOption[@"selectedIndex"] atIndexedSubscript:[selectedOption[@"selectedComponent"] unsignedIntegerValue]];
    _selectedIndex = [NSArray arrayWithArray:tmp_array];
    
    [_selectedComponents setObject:selectedOption atIndexedSubscript:[selectedOption[@"selectedComponent"] unsignedIntegerValue]];
    
    // get the display text for the selected picker vaules
    [self pickerDisplayText];
    
    // bubble the onChange event to React if defined
    if (_onChange) {
        _onChange(@{
            @"selectedIndexes":_selectedIndex,
            @"selectedComponents":_selectedComponents,
        });
    }
}

- (void)pickerDisplayText
{
    // determine the display text for the text field by looping through the selected
    // components and only adding the label text if the value is not blank
    NSString *displayText = @"";
    for (NSDictionary *_component in _selectedComponents) {
        if ([_component[@"value"] length]) {
            // if the display text already has a label value, then add a seperator
            if (![displayText isEqualToString:@""]) {
                displayText = [displayText stringByAppendingString:_seperator];
                displayText = [displayText stringByAppendingString:_component[@"label"]];
            } else {
                displayText = [displayText stringByAppendingString:_component[@"label"]];
            }
        }
    }
    // display the new display text in the display field
    _textInputView.text = displayText;
}
// handle when the previous button is pressed in the keyboard accessory
- (void)onPrevious
{
    [_textInputView resignFirstResponder];
}
// handle when the next button is pressed in the keyboard accessory
- (void)onNext
{
    [_textInputView resignFirstResponder];
}
// handle when the done button is pressed in the keyboard accessory
- (void)onDone
{
    // unfocus the textField
    [_textInputView resignFirstResponder];
}

@end
