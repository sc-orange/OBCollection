//
//  OBCatonData.m
//  OBCollection
//
//  Created by orange on 2021/3/29.
//

#import "OBCatonData.h"

@implementation OBCatonData

- (instancetype)init {
    if (self = [super init]) {
        self.pageName = @"";
        self.catonActionTime = @"";
        self.spendTime = 0;
    }
    return self;
}

- (NSString *)description {
    NSMutableString *dataString = [NSMutableString stringWithFormat:@""];
    [self appendString:self.pageName To:dataString];
    [self appendString:self.catonActionTime To:dataString];
    [self appendIntger:self.spendTime To:dataString];
    return dataString;
}

@end
