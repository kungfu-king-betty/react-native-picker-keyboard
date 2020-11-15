#import "RNDatePicker.h"

#import <React/RCTConvert.h>
#import <React/RCTUtils.h>


@implementation RNDatePicker

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        // default the picker to date mode
        [self setDatePickerMode:UIDatePickerModeDate];
        // default the picker to use the wheel style
        // only if the version is 13.4 or greater
        if (@available(iOS 13.4, *)) {
            [self setPreferredDatePickerStyle:UIDatePickerStyleWheels];
        }
        
        // create the date formatter
        _dateFormatter = [[NSDateFormatter alloc] init];
        // set the date formatter locale
        _dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        
        // create the date formatter
        _fullDateFormatter = [[NSDateFormatter alloc] init];
        // set the date formatter locale
        _fullDateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        _fullDateFormatter.dateStyle = NSDateFormatterFullStyle;
        _fullDateFormatter.timeStyle = NSDateFormatterFullStyle;
        // set the display template
        [_fullDateFormatter setLocalizedDateFormatFromTemplate:@"EEEE MM-dd-yyyy HH:mm:ss Z"];
    }
    return self;
}

- (NSDictionary*)parseTimeRegexMatches:(NSString *)dateString
{
    NSRange searchedRange = NSMakeRange(0, [dateString length]);
    NSError *parseError = nil;
    NSRegularExpression *regex;
    NSArray* matches;
    NSArray<NSString *> *dateComponents;
    // LONG TIME REGEX
    // hh:mm:ss TZ
    regex = [NSRegularExpression
             regularExpressionWithPattern:@"(\\d{1,2})\\:(\\d{1,2})\\:(\\d{1,2})\\s(\\-\\d+)"
             options:0
             error:&parseError];
    matches = [regex matchesInString:dateString options:0 range: searchedRange];
    if (matches.count) {
        dateComponents = @[@"hour", @"minute", @"second", @"timezone"];
        return @{
            @"dateColumns": dateComponents,
            @"dateValues": matches[0]
        };
    }
    // ISO TIME REGEX
    // hh:mm:ss.msZ
    regex = [NSRegularExpression
             regularExpressionWithPattern:@"(\\d{1,2})\\:(\\d{1,2})\\:(\\d{1,2})\\.(\\d+)Z"
             options:0
             error:&parseError];
    matches = [regex matchesInString:dateString options:0 range: searchedRange];
    if (matches.count) {
        dateComponents = @[@"hour", @"minute", @"second", @"millisecond"];
        return @{
            @"dateColumns": dateComponents,
            @"dateValues": matches[0]
        };
    }
    // SHORT TIME REGEX
    // hh:mm(:ss) a
    regex = [NSRegularExpression
             regularExpressionWithPattern:@"(\\d{1,2})\\:(\\d{1,2})(?:\\:)?(\\d{2})?(?:\\s)?(\\w{1,2})?"
             options:0
             error:&parseError];
    matches = [regex matchesInString:dateString options:0 range: searchedRange];
    if (matches.count) {
        dateComponents = @[@"hour", @"minute", @"second", @"tod"];
        return @{
            @"dateColumns": dateComponents,
            @"dateValues": matches[0]
        };
    }
    
    return nil;
}

- (NSDictionary*)parseDateRegexMatches:(NSString *)dateString
{
    NSRange searchedRange = NSMakeRange(0, [dateString length]);
    NSError *parseError = nil;
    NSRegularExpression *regex;
    NSArray* matches;
    NSArray<NSString *> *dateComponents;
    // LONG DATE REGEX
    // www, mmm dd yyyy
    regex = [NSRegularExpression
             regularExpressionWithPattern:@"(\\w{3,5})\\,\\s(\\w{3,4})\\s(\\d{1,2})\\s(\\d{4})"
             options:0
             error:&parseError];
    matches = [regex matchesInString:dateString options:0 range: searchedRange];
    if (matches.count) {
        dateComponents = @[@"weekday", @"month", @"day", @"year"];
        return @{
            @"dateColumns": dateComponents,
            @"dateValues": matches[0]
        };
    }
    // ISO DATE REGEX
    // yyyy-mm-ddThh:mm:ss.msZ
    regex = [NSRegularExpression
             regularExpressionWithPattern:@"(\\d{4})\\-(\\d{1,2})\\-(\\d{1,2})"
             options:0
             error:&parseError];
    matches = [regex matchesInString:dateString options:0 range: searchedRange];
    if (matches.count) {
        dateComponents = @[@"year", @"month", @"day"];
        return @{
            @"dateColumns": dateComponents,
            @"dateValues": matches[0]
        };
    }
    // SHORT DATE REGEX
    // mm/dd/yy(yy)
    regex = [NSRegularExpression
             regularExpressionWithPattern:@"(\\d{1,2})\\/(\\d{1,2})\\/(\\d{2,4})"
             options:0
             error:&parseError];
    matches = [regex matchesInString:dateString options:0 range: searchedRange];
    if (matches.count) {
        dateComponents = @[@"month", @"day", @"year"];
        return @{
            @"dateColumns": dateComponents,
            @"dateValues": matches[0]
        };
    }
    
    return nil;
}

- (NSDictionary*)parseDateTimeRegexMatches:(NSString *)dateString
{
    NSRange searchedRange = NSMakeRange(0, [dateString length]);
    NSError *parseError = nil;
    NSRegularExpression *regex;
    NSArray* matches;
    NSArray<NSString *> *dateComponents;
    // LONG DATETIME REGEX
    // www, mmm dd yyyyThh:mm:ss TZ
    regex = [NSRegularExpression
             regularExpressionWithPattern:@"(\\w{3,5})\\,\\s(\\w{3,4})\\s(\\d{1,2})\\s(\\d{4})T(\\d{1,2})\\:(\\d{1,2})\\:(\\d{1,2})\\s(\\-\\d+)"
             options:0
             error:&parseError];
    matches = [regex matchesInString:dateString options:0 range: searchedRange];
    if (matches.count) {
        dateComponents = @[@"weekday", @"month", @"day", @"year", @"hour", @"minute", @"second", @"timezone"];
        return @{
            @"dateColumns": dateComponents,
            @"dateValues": matches[0]
        };
    }
    // ISO DATETIME REGEX
    // yyyy-mm-ddThh:mm:ss.msZ
    regex = [NSRegularExpression
             regularExpressionWithPattern:@"(\\d{4})\\-(\\d{1,2})\\-(\\d{1,2})T(\\d{1,2})\\:(\\d{1,2})\\:(\\d{1,2})\\.(\\d+)Z"
             options:0
             error:&parseError];
    matches = [regex matchesInString:dateString options:0 range: searchedRange];
    if (matches.count) {
        dateComponents = @[@"year", @"month", @"day", @"hour", @"minute", @"second", @"millisecond"];
        return @{
            @"dateColumns": dateComponents,
            @"dateValues": matches[0]
        };
    }
    // SHORT DATETIME REGEX
    // mm/dd/yy(yy) hh:mm(:ss) a
    regex = [NSRegularExpression
             regularExpressionWithPattern:@"(\\d{1,2})\\/(\\d{1,2})\\/(\\d{2,4})\\s(\\d{1,2})\\:(\\d{1,2})(?:\\:)?(\\d{2})?(?:\\s)?(\\w{1,2})?"
             options:0
             error:&parseError];
    matches = [regex matchesInString:dateString options:0 range: searchedRange];
    if (matches.count) {
        dateComponents = @[@"month", @"day", @"year", @"hour", @"minute", @"second", @"tod"];
        return @{
            @"dateColumns": dateComponents,
            @"dateValues": matches[0]
        };
    }
    
    return nil;
}

- (NSDictionary*)parseDate:(NSString *)dateString dateMode:(NSString *)dateMode
{
    NSDictionary *regexObject;
    
    if ([[dateMode lowercaseString] isEqualToString:@"time"]) {
        regexObject = [self parseTimeRegexMatches:dateString];
    } else if ([[dateMode lowercaseString] isEqualToString:@"datetime"]) {
        regexObject = [self parseDateTimeRegexMatches:dateString];
    } else {
        regexObject = [self parseDateRegexMatches:dateString];
    }
    
    NSArray *regexKeys = regexObject[@"dateColumns"];
    NSTextCheckingResult *regexMatch = regexObject[@"dateValues"];
    
    NSRange groupRange;
    NSString *tmpValue;
    NSMutableDictionary *returnValues = [[NSMutableDictionary alloc] initWithCapacity:[regexMatch numberOfRanges]-1];
    
    for (NSUInteger i=1; i < [regexMatch numberOfRanges]; i++) {
        groupRange = [regexMatch rangeAtIndex:i];
        if (NSMaxRange(groupRange) <= [dateString length]) {
            tmpValue = [dateString substringWithRange:groupRange];
        } else {
            tmpValue = @"";
        }
        
        if ([regexKeys[i-1] isEqualToString:@"year"] && [tmpValue length] == 2) {
            NSString *tmpYear = @"20";
            tmpYear = [tmpYear stringByAppendingString:tmpValue];
            tmpValue = tmpYear;
        }
        
        [returnValues setObject:tmpValue forKey:regexKeys[i-1]];
    }
    
    NSLog(@"RETURN VALUES: %@", returnValues);
    
    return [[NSDictionary alloc] initWithDictionary:returnValues];
}

@end
