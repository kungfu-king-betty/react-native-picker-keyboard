#import "RNPickerKeyboard.h"
#import "IOSPickerKeyboard.h"

@interface RNPickerKeyboard()

@property (nonatomic, retain) IOSPickerKeyboard *picker;

@end

@implementation RNPickerKeyboard

- (instancetype)init {
    self = [super init];
    if (self) {
        self.picker = [[IOSPickerKeyboard alloc] init];
    }
    return self;
}

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(show:(NSString *)text)
{
    [self.picker showToast:text];
}

@end
