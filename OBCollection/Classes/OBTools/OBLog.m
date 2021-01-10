//
//  OBLog.m
//  OBCollection
//
//  Created by orange on 2021/1/10.
//

#import "OBLog.h"

static BOOL _canOpen = NO;

@implementation OBLog

+ (void)canOpenLog:(BOOL)open {
    _canOpen = open;
}

+ (void)print:(NSString *)format, ... {
    if (_canOpen) {
        va_list ap;
        va_start(ap, format);
        NSString *logMsg = [[NSString alloc] initWithFormat:format locale:[NSLocale currentLocale] arguments:ap];
        va_end(ap);
        NSLog(@"【OBCollection】: %@",logMsg);
    }
}

@end
