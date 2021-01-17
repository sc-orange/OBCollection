//
//  NSString+OBDateFormat.m
//  OBCollection
//
//  Created by orange on 2021/1/17.
//

#import "NSString+OBDateFormat.h"

@implementation NSString (OBDateFormat)

- (NSString *)dateStringToFormat:(NSString *)format {
    NSDate *date = [self ob_dateWithDateString:self];
    return [OBUtils timeFromDate:date Format:format];
}

- (NSDate *)ob_dateWithDateString:(NSString *)dateString {
    NSDate *date = nil;
    date = [self ob_dateWithFormat_yyyy_MM_dd_HH_mm_ss_string:dateString];
    if(date) return date;
    date = [self ob_dateWithFormat_yyyy_MM_dd_HH_mm_string:dateString];
    if(date) return date;
    date = [self ob_dateWithFormat_yyyy_MM_dd_HH_string:dateString];
    if(date) return date;
    date = [self ob_dateWithFormat_yyyy_MM_dd_string:dateString];
    if(date) return date;
    date = [self ob_dateWithFormat_yyyy_MM_string:dateString];
    if(date) return date;
    date = [self ob_dateWithFormat_yyyy_MM_dd_T_HH_mm_ss_Z_string:dateString];
    if(date) return date;
    return nil;
}

- (NSDate *)ob_dateWithFormat_yyyy_MM_dd_T_HH_mm_ss_Z_string:(NSString *)string {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
    [dateFormat setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    if (string.length < 19) {
        return nil;
    }
    NSString *timeString =[string substringToIndex:19];
    NSString *time = [NSString stringWithFormat:@"%@Z",timeString];
    return [dateFormat dateFromString:time];
}

- (NSDate *)ob_dateWithFormat_yyyy_MM_dd_HH_mm_ss_string:(NSString *)string {
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date =[dateFormat dateFromString:string];
    return date;
}

- (NSDate *)ob_dateWithFormat_yyyy_MM_dd_HH_mm_string:(NSString *)string {
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date =[dateFormat dateFromString:string];
    return date;
}

- (NSDate *)ob_dateWithFormat_yyyy_MM_dd_HH_string:(NSString *)string {
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH"];
    NSDate *date =[dateFormat dateFromString:string];
    return date;
}

- (NSDate *)ob_dateWithFormat_yyyy_MM_dd_string:(NSString *)string {
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *date =[dateFormat dateFromString:string];
    return date;
}

- (NSDate *)ob_dateWithFormat_yyyy_MM_string:(NSString *)string {
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM"];
    NSDate *date =[dateFormat dateFromString:string];
    return date;
}

@end
