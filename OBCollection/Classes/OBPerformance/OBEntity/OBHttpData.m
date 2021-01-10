//
//  OBHttpData.m
//  OBCollection
//
//  Created by orange on 2021/1/10.
//

#import "OBHttpData.h"

@implementation OBHttpData

- (instancetype)init
{
    if (self = [super init]) {
        self.url = @"";
        self.requestHead = [NSDictionary dictionary];
        self.requestStartSeconds = 0;
        self.requestStartTime = @"";
        self.responseTime = @"";
        self.responseSpacing = 0;
        self.responseStatusCode = @"";
        self.responseHeader = [NSDictionary dictionary];
        
        self.errorMsg = @"";
    }
    return self;
}

- (NSInteger)ob_responseTime {
    NSInteger time = [OBUtils currentSeconds] - self.requestStartSeconds;
    return time ? time : 0;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    OBHttpData *data = OBHttpData.alloc.init;
    data.url = self.url;
    data.requestHead = self.requestHead;
    data.requestStartSeconds = self.requestStartSeconds;
    data.requestStartTime = self.requestStartTime;
    data.responseTime = self.responseTime;
    data.responseSpacing = self.responseSpacing;
    data.responseStatusCode = self.responseStatusCode;
    data.responseHeader = self.responseHeader;
    return data;
}

@end
