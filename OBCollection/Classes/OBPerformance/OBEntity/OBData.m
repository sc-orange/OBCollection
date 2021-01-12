//
//  OBData.m
//  ForORTest
//
//  Created by orange on 2020/11/23.
//

#import "OBData.h"

@implementation OBData

- (NSString *)description {
    return @"";
}

- (void)appendString:(NSString *)string To:(NSMutableString *)muString {
    if (StringValid(muString)) {
        [muString appendString:@"\n"];
    }
    StringValid(string) ? [muString appendString:string] : [muString appendString:@""];
}

- (void)appendIntger:(NSInteger)intger To:(NSMutableString *)muString {
    if (StringValid(muString)) {
        [muString appendString:@"\n"];
    }
    [muString appendFormat:@"%ld", intger];
}

@end
