#import "RNPickerKeyboard.h"
#import "RNKeyboard.h"
#import "RNPicker.h"
#import "RNDatePicker.h"

#import <React/RCTUtils.h>
#import <React/RCTUIManager.h>
#import <React/RCTInputAccessoryView.h>

#import <objc/runtime.h>


@implementation RNPickerKeyboard
{
    RNPicker *_pickerView;
    RNDatePicker *_dateView;
    
    UIToolbar *_accessory;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _showClearButton = NO;
        _datePicker = NO;
        _inputAccessoryViewShow = YES;
        // create the RNPicker UIPickerView
        _pickerView = [RNPicker new];
        
        // create the RNDatePicker UIDatePickerView
        _dateView = [RNDatePicker new];
        
        // create and style the RNKeyboard UITextField
        _textInputView = [[RNKeyboard alloc] initWithFrame:self.bounds];
        _textInputView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _textInputView.inputView = _pickerView;
        
        // create the input accessoty view
        _accessory = [UIToolbar new];
        // create and add the input accessory view buttons
        NSMutableArray* buttons = [[NSMutableArray alloc] init];
        // Prev/Up button first
        UIBarButtonItem* prevButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Previous Arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(onPrevPress)];
        [prevButton setEnabled:NO];
        [buttons addObject:prevButton];
        // Next/Down button next
        UIBarButtonItem* nextButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Next Arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(onNextPress)];
        [nextButton setEnabled:NO];
        [buttons addObject:nextButton];
        // spacer button to have buttons be on left and right sides
        UIBarButtonItem* spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        [buttons addObject:spacer];
        // done button last aka right side
        UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onDonePress)];
        [buttons addObject:doneButton];
        // set the input accessory buttons and their size description
        [_accessory setItems:buttons];
        [_accessory sizeToFit];
        
        // add the input accessory view to the responder
        _textInputView.inputAccessoryView = _accessory;
        // PICKER CHANGE EVENTS
        // add a listener for the Picker Value change
        [[NSNotificationCenter defaultCenter] addObserver:self
                                              selector:@selector(onPickerChange)
                                              name:@"UIPickerViewItemChangeNotification"
                                              object:_pickerView];
        // add a listener for when the date picker changes
        [_dateView addTarget:self action:@selector(onDateChange:) forControlEvents:UIControlEventValueChanged];
        // TEXTFIELD CHANGE EVENTS
        // add a listener for when the keybaord opens i.e. the textfield is in focus
        [[NSNotificationCenter defaultCenter] addObserver:self
                                              selector:@selector(onKeyboardDidOpen)
                                              name:@"UITextFieldKeyboardIsOpen"
                                              object:_textInputView];
        // add a listener for when the text is cleared by the user
        [[NSNotificationCenter defaultCenter] addObserver:self
                                              selector:@selector(onClear)
                                              name:@"UITextFieldDidClear"
                                              object:_textInputView];
        
        // add the textfield to the view
        [self addSubview:_textInputView];
    }
    
    return self;
}

#pragma mark - React Property Setter Functions
// function to set the RNKeyboard placeholder
- (void)setPlaceholder:(NSString*)placeholder
{
    _placeholder = placeholder;
    _textInputView.placeholder = placeholder;
    
    NSLog(@"setPlaceholder Finished");
}
// function to set the styling for the RNDatePicker
- (void)setDateStyle:(NSString *)dateStyle
{
    _dateStyle = dateStyle;
    
    if (@available(iOS 13.4, *)) {
        if ([_dateStyle isEqualToString:@"inline"]) {
            if (@available(iOS 14.0, *)) {
                [_dateView setPreferredDatePickerStyle:UIDatePickerStyleInline];
            } else {
                [_dateView setPreferredDatePickerStyle:UIDatePickerStyleAutomatic];
            }
        } else if ([_dateStyle isEqualToString:@"compact"]) {
            [_dateView setPreferredDatePickerStyle:UIDatePickerStyleCompact];
        } else {
            [_dateView setPreferredDatePickerStyle:UIDatePickerStyleWheels];
        }
    }
    
    NSLog(@"setDateStyle Finished");
}
// function to set the text alignment of the RNKeyboard UITextField
- (void)setTextAlign:(NSString*)textAlign
{
    if ([textAlign isEqualToString:@"center"] || [textAlign isEqualToString:@"C"]) {
        _textInputView.textAlignment = NSTextAlignmentCenter;
    } else if ([textAlign isEqualToString:@"right"] || [textAlign isEqualToString:@"R"]) {
        _textInputView.textAlignment = NSTextAlignmentRight;
    } else {
        _textInputView.textAlignment = NSTextAlignmentLeft;
    }
    
    NSLog(@"setTextAlign Finished");
}

- (void)setSelectedValue:(NSArray *)selectedValue
{
    _selectedValue = selectedValue;
    
    NSLog(@"setSelectedValue Finished");
}
// function to set the amount of columns in the RNPicker
- (void)setComponentCount:(NSUInteger)componentCount
{
    _pickerView.componentCount = componentCount;
    
    _selectedComponents = [NSMutableArray arrayWithCapacity:componentCount];
    
    NSLog(@"setComponentCount Finished");
}

- (void)setShowClearButton:(BOOL)showClearButton
{
    _showClearButton = showClearButton;
    [_textInputView setShowClearButton:showClearButton];
}
// function to set the inputView of the textField to either RNDatePicker or RNPicker
- (void)setDatePicker:(BOOL)datePicker
{
    _datePicker = datePicker;
    
    if (_datePicker) {
        _textInputView.inputView = _dateView;
        _textInputView.placeholder = @"Select a date...";
    } else {
        _textInputView.inputView = _pickerView;
        _textInputView.placeholder = @"Select an option...";
    }
    
    if ([_placeholder length]) {
        _textInputView.placeholder = _placeholder;
    }
    /*
    if (_selectedValue.count) {
        if (_datePicker) {
            [_selectedComponents setObject:@{@"dateValue":_selectedValue[0]} atIndexedSubscript:0];
            
            NSCalendar *calendar = [NSCalendar currentCalendar];
            unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
            NSDate *date = [NSDate date];
            
            NSDateComponents *components = [calendar components:unitFlags fromDate:date];
            components.month = 11;
            components.day = 4;
            components.year = 20;
            components.hour = 5;
            components.minute = 50;
            components.second = 23;
            NSLog(@"SELECTED DATE: %@", [calendar dateFromComponents:components]);
            [_dateView setDate:[calendar dateFromComponents:components] animated:YES];
            
            [self onDateChange:_dateView];
        } else {
            NSNumber* tmpIndex = [NSNumber numberWithInt:0];
            
            while ([tmpIndex intValue] < _selectedValue.count) {
                [_pickerView setIndex:_selectedValue[[tmpIndex intValue]] forComponent:[tmpIndex intValue]];
                
                tmpIndex = [NSNumber numberWithInt:[tmpIndex intValue]+1];
            }
        }
    }
    
    [self pickerDisplayText];
    */
    NSLog(@"setDatePicker Finished");
}

- (void)setSeperator:(NSString *)seperator
{
    _seperator = seperator;
    
    NSLog(@"setSeperator Finished");
}
// function to set the mode of the RNDatePicker
- (void)setDateMode:(NSString *)dateMode
{
    _dateMode = dateMode;
    
    if ([_dateMode isEqualToString:@"time"]) {
        [_dateView setDatePickerMode:UIDatePickerModeTime];
        
        _dateView.dateFormatter.dateStyle = NSDateFormatterNoStyle;
        _dateView.dateFormatter.timeStyle = NSDateFormatterMediumStyle;
        // set the display template
        [_dateView.dateFormatter setLocalizedDateFormatFromTemplate:@"hh:mma"];
        // set the placeholder
        _textInputView.placeholder = @"Select a time of day...";
    } else if ([_dateMode isEqualToString:@"datetime"]) {
        [_dateView setDatePickerMode:UIDatePickerModeDateAndTime];
        
        _dateView.dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        _dateView.dateFormatter.timeStyle = NSDateFormatterFullStyle;
        // set the display template
        [_dateView.dateFormatter setLocalizedDateFormatFromTemplate:@"EMMMdhh:mma"];
        // set the placeholder text
        _textInputView.placeholder = @"Select a date and time...";
    } else {
        [_dateView setDatePickerMode:UIDatePickerModeDate];
        
        _dateView.dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        _dateView.dateFormatter.timeStyle = NSDateFormatterNoStyle;
        // set the display template
        [_dateView.dateFormatter setLocalizedDateFormatFromTemplate:@"EMMMd"];
        // set the placeholder
        _textInputView.placeholder = @"Select a date...";
    }
    
    if ([_placeholder length]) {
        _textInputView.placeholder = _placeholder;
    }
    
    NSLog(@"setDateMode Finished");
}

- (void)setOnChange:(RCTBubblingEventBlock)onChange
{
    _onChange = onChange;
    
    NSLog(@"setOnChange Finished");
}

- (void)setOnPrev:(RCTBubblingEventBlock)onPrev
{
    _onPrev = onPrev;
    
    if (_onPrev) {
        [_accessory.items[0] setEnabled:YES];
    } else {
        [_accessory.items[0] setEnabled:NO];
    }
    
    NSLog(@"setOnPrev Finished");
}

- (void)setOnNext:(RCTBubblingEventBlock)onNext
{
    _onNext = onNext;
    
    if (_onNext) {
        [_accessory.items[1] setEnabled:YES];
    } else {
        [_accessory.items[1] setEnabled:NO];
    }
    
    NSLog(@"setOnNext Finished");
}

- (void)setInputAccessoryViewShow:(BOOL)inputAccessoryViewShow
{
    _inputAccessoryViewShow = inputAccessoryViewShow;
    
    if (_inputAccessoryViewShow) {
        if (_inputAccessoryViewID) {
            [self setInputAccessoryViewID:_inputAccessoryViewID];
        } else {
            _textInputView.inputAccessoryView = _accessory;
        }
    } else {
        _textInputView.inputAccessoryView = nil;
    }
    
    NSLog(@"setInputAccessoryViewShow Finished");
}

- (void)setInputAccessoryViewID:(NSString *)inputAccessoryViewID
{
    // set the inputViewAccessoryID
    _inputAccessoryViewID = inputAccessoryViewID;
    
    // if the inputAccessoryView should be shown, then get the view from react
    if (_inputAccessoryViewShow) {
        __weak RNPickerKeyboard *weakSelf = self;
        // use the bridge uimanager to get the rootView
        [_bridge.uiManager rootViewForReactTag:self.reactTag withCompletion:^(UIView *view) {
            // if the rootview exists, then get the accessory view
            RNPickerKeyboard *strongSelf = weakSelf;
            if (view) {
               UIView *accessoryView = [strongSelf->_bridge.uiManager viewForNativeID:inputAccessoryViewID
                                                                       withRootTag:view.reactTag];
                // if the accessory view exists, and is a RCTInputAccessoryView, then set the input accessory view
                if (accessoryView && [accessoryView isKindOfClass:[RCTInputAccessoryView class]]) {
                    strongSelf.textInputView.inputAccessoryView = ((RCTInputAccessoryView *)accessoryView).inputAccessoryView;
                    // reload the input view if the picker keyboard is in focus
                    if (strongSelf.textInputView.isFirstResponder) {
                        [strongSelf.textInputView reloadInputViews];
                    }
                }
            }
        }];
    }
    
    NSLog(@"setInputAccessoryViewID Finished");
}
// function to set the items of the RNPicker
- (void)setItems:(NSArray<NSDictionary *> *)items
{
    
    // initalize the index values to be used in the loop over components
    NSUInteger loopIndex = 0, offsetIndex = 0, endIndex = 0;
    // initalize the arrays to be used in the loop over components
    NSArray<NSArray<NSDictionary *> *> * items_final = [NSArray array];
    
    if (items.count) {
        NSArray<NSDictionary *> *test_array = [NSArray array];
        // loop through the given items while counting the component columns
        while ((_datePicker && loopIndex < 1) || (!_datePicker && loopIndex < _pickerView.componentCount)) {
            // start with a copy of the array and exclude any objects already copied
            test_array = [items subarrayWithRange:NSMakeRange(offsetIndex, items.count-offsetIndex)];
            // get the offset index of the current blank start option
            // look for the first option with a blank value for the @value key
            offsetIndex = [test_array indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop){
                NSDictionary *itm = (NSDictionary *)obj;
                return [itm[@"value"] isEqualToString:@""];
            }];
            if (offsetIndex == NSNotFound) {
                offsetIndex = 0;
            }
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
            if (endIndex == NSNotFound) {
                endIndex = (test_array.count > 0) ? test_array.count : 0;
            }
            
            // copy the items from the array using the offset and end index values as the range
            NSArray<NSDictionary *> * componentItems = [test_array subarrayWithRange:NSMakeRange(offsetIndex, (endIndex < test_array.count) ? endIndex-offsetIndex : (test_array.count)-offsetIndex)];
            // add the copied array range as its own array to the final array
            items_final = [items_final arrayByAddingObject:componentItems];
            
            // update the selected component value
            if (_datePicker) {
                [_selectedComponents setObject:@{@"date":_selectedValue[loopIndex]} atIndexedSubscript:loopIndex];
            } else {
                [_selectedComponents setObject:[componentItems objectAtIndex:[_selectedValue[loopIndex] unsignedIntValue]] atIndexedSubscript:loopIndex];
            }
            // update the offset index to the end index for the next itration to
            // remove the previous objects just copied
            offsetIndex = endIndex;
            // increment the loop index
            loopIndex++;
        }
    } else {
        NSArray<NSDictionary *> *items_temp = [NSArray arrayWithObject:@{ @"label":@"No items to choose from...",
            @"value":@""
        }];
        
        items_final = [items_final arrayByAddingObject:items_temp];
    }
    // copy the items to the pickerView item list
    _pickerView.items = [items_final copy];
    [self setNeedsLayout];
    
    [self pickerDisplayText];
    
    NSLog(@"setItems Finished");
}
// function to add a blank option to the beginning of the items list
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
// function to determine the display text from the selected component options
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
        if ([_component[@"date"] length]) {
            NSDictionary* dateComponents = [_dateView parseDate:_component[@"date"] dateMode:_dateMode];
            // Set the date using the calendar date components
            // create the calendar
            NSCalendar *calendar = [NSCalendar currentCalendar];
            // create the component flags
            unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
            NSDate *date = [NSDate date];
            // create the componets object
            NSDateComponents *components = [calendar components:unitFlags fromDate:date];
            // set the component date values
            if ([dateComponents objectForKey:@"month"]) {
                [components setMonth:[(NSNumber*)dateComponents[@"month"] intValue]];
            }
            if ([dateComponents objectForKey:@"day"]) {
                [components setDay:[(NSNumber*)dateComponents[@"day"] intValue]];
            }
            if ([dateComponents objectForKey:@"year"]) {
                [components setYear:[(NSNumber*)dateComponents[@"year"] intValue]];
            }
            // set the component time values if provided
            if ([dateComponents objectForKey:@"hour"]) {
                NSString *calculatedHour = dateComponents[@"hour"];
                // account for the time being in the pm and convert to military time
                // for consistent display
                if ([dateComponents objectForKey:@"tod"] && [[dateComponents objectForKey:@"tod"] isEqualToString:@"p"]) {
                    int paddingHour = 12;
                    // create numberFormatter to be able to convert the number string to
                    // and actual integer number for use with NSNumber
                    NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
                    numFormatter.numberStyle = NSNumberFormatterDecimalStyle;
                    NSNumber *currentHour = [numFormatter numberFromString:dateComponents[@"hour"]];
                    // increment the hour value
                    currentHour = [NSNumber numberWithInt:[currentHour intValue]+paddingHour];
                    // set the hour value back to a string for usage
                    calculatedHour = [currentHour stringValue];
                }
                [components setHour:[(NSNumber*)calculatedHour intValue]];
            }
            if ([dateComponents objectForKey:@"minute"]) {
                [components setMinute:[(NSNumber*)dateComponents[@"minute"] intValue]];
            }
            if ([dateComponents objectForKey:@"second"]) {
                [components setSecond:[(NSNumber*)dateComponents[@"second"] intValue]];
            }
            if ([dateComponents objectForKey:@"millisecond"]) {
                [components setSecond:[(NSNumber*)dateComponents[@"millisecond"] intValue]];
            }
            
            NSLog(@"DATE COMPONENTS: %@", components);
            // set the display text using the date from the calendare components
            displayText = [_dateView.dateFormatter stringFromDate:[calendar dateFromComponents:components]];
        }
    }
    // display the new display text in the display field
    _textInputView.text = displayText;
}

# pragma mark - Event Handlers
// handler to set the selected options when the picker opens
- (void)onKeyboardDidOpen
{
    if (_datePicker) {
        // seperate the date string into the date value and time value
        NSDictionary* dateComponents = [_dateView parseDate:_selectedValue[0] dateMode:_dateMode];
        // Set the date using the calendar date components
        // create the calendar
        NSCalendar *calendar = [NSCalendar currentCalendar];
        // create the component flags
        unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDate *date = [NSDate date];
        // create the componets object
        NSDateComponents *components = [calendar components:unitFlags fromDate:date];
        // set the component date values
        // set the component date values
        if ([dateComponents objectForKey:@"month"]) {
            [components setMonth:[(NSNumber*)dateComponents[@"month"] intValue]];
        }
        if ([dateComponents objectForKey:@"day"]) {
            [components setDay:[(NSNumber*)dateComponents[@"day"] intValue]];
        }
        if ([dateComponents objectForKey:@"year"]) {
            [components setYear:[(NSNumber*)dateComponents[@"year"] intValue]];
        }
        // set the component time values if provided
        if ([dateComponents objectForKey:@"hour"]) {
            NSString *calculatedHour = dateComponents[@"hour"];
            // account for the time being in the pm and convert to military time
            // for consistent display
            if ([dateComponents objectForKey:@"tod"] && [[dateComponents objectForKey:@"tod"] isEqualToString:@"p"]) {
                int paddingHour = 12;
                // create numberFormatter to be able to convert the number string to
                // and actual integer number for use with NSNumber
                NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
                numFormatter.numberStyle = NSNumberFormatterDecimalStyle;
                NSNumber *currentHour = [numFormatter numberFromString:dateComponents[@"hour"]];
                // increment the hour value
                currentHour = [NSNumber numberWithInt:[currentHour intValue]+paddingHour];
                // set the hour value back to a string for usage
                calculatedHour = [currentHour stringValue];
            }
            [components setHour:[(NSNumber*)calculatedHour intValue]];
        }
        if ([dateComponents objectForKey:@"minute"]) {
            [components setMinute:[(NSNumber*)dateComponents[@"minute"] intValue]];
        }
        if ([dateComponents objectForKey:@"second"]) {
            [components setSecond:[(NSNumber*)dateComponents[@"second"] intValue]];
        }
        if ([dateComponents objectForKey:@"millisecond"]) {
            [components setSecond:[(NSNumber*)dateComponents[@"millisecond"] intValue]];
        }
        NSLog(@"SELECTED DATE: %@", [calendar dateFromComponents:components]);
        [_dateView setDate:[calendar dateFromComponents:components] animated:YES];
        
        [self onDateChange:_dateView];
    } else {
        NSNumber *tmp_index = 0;
        for (NSNumber *tmp in _selectedValue) {
            [_pickerView setIndex:[tmp integerValue] forComponent:[tmp_index intValue]];

            tmp_index = [NSNumber numberWithInt:[tmp_index intValue]+1];
        }
    }
}
// handler for when the picker value change notification is called
- (void)onPickerChange
{
    NSDictionary *selectedOption = _pickerView.selectedOption;
    
    // set the select component and index locally
    NSMutableArray* tmp_array = [NSMutableArray arrayWithArray:_selectedValue];
    [tmp_array setObject:selectedOption[@"selectedIndex"] atIndexedSubscript:[selectedOption[@"selectedComponent"] unsignedIntegerValue]];
    _selectedValue = [NSArray arrayWithArray:tmp_array];
    
    [_selectedComponents setObject:selectedOption atIndexedSubscript:[selectedOption[@"selectedComponent"] unsignedIntegerValue]];
    
    // get the display text for the selected picker vaules
    [self pickerDisplayText];
    
    // set the on change event to JS
    [self onValueChange];
}
// handler for when the date picker selected options changes
- (void)onDateChange:(UIDatePicker *)datePicker
{
    // set the text value from the selected date option
    _textInputView.text = [_dateView.dateFormatter stringFromDate:datePicker.date];
    
    // set the select component and index locally
    NSMutableArray* tmp_array = [NSMutableArray arrayWithCapacity:1];
    [tmp_array setObject:[_dateView.fullDateFormatter stringFromDate:datePicker.date] atIndexedSubscript:0];
    _selectedValue = [NSArray arrayWithArray:tmp_array];
    
    NSLog(@"DATE: %@", datePicker.date);
    [_selectedComponents setObject:@{@"dateType":_dateMode, @"dateValue": [_dateView.dateFormatter stringFromDate:datePicker.date]} atIndexedSubscript:0];
    
    // set the on change event to JS
    [self onValueChange];
}
// handler function for when the text is cleared
- (void)onClear
{
    NSMutableArray* tmp_array = [NSMutableArray arrayWithCapacity:_selectedComponents.count];
    NSNumber* tmpIndex = [NSNumber numberWithInt:0];
    
    while ([tmpIndex intValue] < _selectedComponents.count) {
        if (_datePicker) {
            [tmp_array setObject:@{@"date":@""} atIndexedSubscript:[tmpIndex intValue]];
        } else {
            [tmp_array setObject:[NSNumber numberWithInt:0] atIndexedSubscript:[tmpIndex intValue]];
        }
        [_selectedComponents setObject:@{@"value":@""} atIndexedSubscript:[tmpIndex intValue]];
        [_pickerView setIndex:0 forComponent:[tmpIndex intValue]];
        
        tmpIndex = [NSNumber numberWithInt:[tmpIndex intValue]+1];
    }
    
    _selectedValue = [NSArray arrayWithArray:tmp_array];
    
    [self onValueChange];
}
// handler function to bubble the change event to JS
- (void)onValueChange
{
    // bubble the onChange event to React if defined
    if (_onChange) {
        _onChange(@{
            @"selectedIndexes":_selectedValue,
            @"selectedComponents":_selectedComponents,
        });
    }
}
// handle when the previous button is pressed in the keyboard accessory
- (void)onPrevPress
{
//    [_textInputView resignFirstResponder];
    if (_onPrev) {
        _onPrev(@{});
    }
}
// handle when the next button is pressed in the keyboard accessory
- (void)onNextPress
{
//    [_textInputView resignFirstResponder];
    if (_onNext) {
        _onNext(@{});
    }
}
// handle when the done button is pressed in the keyboard accessory
- (void)onDonePress
{
    NSLog(@"Done Button Pressed");
    // unfocus the textField
    [_textInputView resignFirstResponder];
}

#pragma mark - Helper Functions
- (NSDate*)parseDateFromString:(NSString*)dateString
{
    NSDictionary* dateComponents = [_dateView parseDate:dateString dateMode:_dateMode];
    // Set the date using the calendar date components
    // create the calendar
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // create the component flags
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDate *date = [NSDate date];
    // create the componets object
    NSDateComponents *components = [calendar components:unitFlags fromDate:date];
    // set the component date values
    if ([dateComponents objectForKey:@"month"]) {
        [components setMonth:[(NSNumber*)dateComponents[@"month"] intValue]];
    }
    if ([dateComponents objectForKey:@"day"]) {
        [components setDay:[(NSNumber*)dateComponents[@"day"] intValue]];
    }
    if ([dateComponents objectForKey:@"year"]) {
        [components setYear:[(NSNumber*)dateComponents[@"year"] intValue]];
    }
    // set the component time values if provided
    if ([dateComponents objectForKey:@"hour"]) {
        NSString *calculatedHour = dateComponents[@"hour"];
        // account for the time being in the pm and convert to military time
        // for consistent display
        if ([dateComponents objectForKey:@"tod"] && [[dateComponents objectForKey:@"tod"] isEqualToString:@"p"]) {
            int paddingHour = 12;
            // create numberFormatter to be able to convert the number string to
            // and actual integer number for use with NSNumber
            NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
            numFormatter.numberStyle = NSNumberFormatterDecimalStyle;
            NSNumber *currentHour = [numFormatter numberFromString:dateComponents[@"hour"]];
            // increment the hour value
            currentHour = [NSNumber numberWithInt:[currentHour intValue]+paddingHour];
            // set the hour value back to a string for usage
            calculatedHour = [currentHour stringValue];
        }
        [components setHour:[(NSNumber*)calculatedHour intValue]];
    }
    if ([dateComponents objectForKey:@"minute"]) {
        [components setMinute:[(NSNumber*)dateComponents[@"minute"] intValue]];
    }
    if ([dateComponents objectForKey:@"second"]) {
        [components setSecond:[(NSNumber*)dateComponents[@"second"] intValue]];
    }
    if ([dateComponents objectForKey:@"millisecond"]) {
        [components setSecond:[(NSNumber*)dateComponents[@"millisecond"] intValue]];
    }
    
    NSLog(@"DATE COMPONENTS: %@", components);
    
    return [calendar dateFromComponents:components];
}

@end
