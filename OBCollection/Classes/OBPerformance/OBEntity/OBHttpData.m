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

- (NSString *)description {
    NSMutableString *dataString = [NSMutableString stringWithFormat:@""];
    if ([self.url containsString:@"|"]) {
        self.url = [NSString stringWithString:[self.url stringByReplacingOccurrencesOfString:@"|" withString:@"?"]];
    }
    [self appendString:[NSString stringWithFormat:@"请求url:%@",self.url] To:dataString];
    [self appendString:[NSString stringWithFormat:@"请求头:%@",[OBUtils dictionaryToString:self.requestHead]] To:dataString];
    [self appendString:[NSString stringWithFormat:@"请求开始时间:%@",self.requestStartTime] To:dataString];
    [self appendString:[NSString stringWithFormat:@"请求响应时间:%@",self.responseTime] To:dataString];
    [self appendString:[NSString stringWithFormat:@"响应间隔:%ld",(long)self.responseSpacing] To:dataString];
    [self appendString:[NSString stringWithFormat:@"状态码:%@",self.responseStatusCode] To:dataString];
    [self appendString:[NSString stringWithFormat:@"响应头:%@",[OBUtils dictionaryToString:self.responseHeader]] To:dataString];
    
    if (StringValid(self.errorMsg)) {
        [self appendString:[NSString stringWithFormat:@"错误信息:%@",self.errorMsg] To:dataString];
    }
    return dataString;
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
    
    data.errorMsg = self.errorMsg;
    return data;
}

@end
