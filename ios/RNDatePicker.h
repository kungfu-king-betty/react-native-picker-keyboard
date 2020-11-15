#import <UIKit/UIKit.h>

@interface RNDatePicker : UIDatePicker

@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) NSDateFormatter *fullDateFormatter;

- (NSDictionary*)parseDate:(NSString *)dateString dateMode:(NSString *)dateMode;

@end
