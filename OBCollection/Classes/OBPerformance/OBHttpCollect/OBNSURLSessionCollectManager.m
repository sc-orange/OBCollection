//
//  OBNSURLSessionCollectManager.m
//  ForORTest
//
//  Created by orange on 2020/11/28.
//

#import "OBNSURLSessionCollectManager.h"

static OBNSURLSessionCollectManager *_manager = nil;

@interface OBNSURLSessionCollectManager()
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, OBHttpData *> *httpDataDict;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSURLSessionTask *> *dataTaskDict;
@end

@implementation OBNSURLSessionCollectManager

+ (OBNSURLSessionCollectManager *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[OBNSURLSessionCollectManager alloc] init];
    });
    return _manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.httpDataDict = [NSMutableDictionary dictionary];
        self.dataTaskDict = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)addHttpDataWithTask:(NSURLSessionTask *)task {
    if (task && self.httpDataDict) {
        OBHttpData *httpData = [[OBHttpData alloc] init];
        NSString *url = [[NSString alloc] initWithString:[[task.originalRequest URL] absoluteString]];
        httpData.url = url;
        httpData.requestStartTime = [OBUtils currentTime];
        httpData.requestStartSeconds = [OBUtils currentSeconds];
        NSNumber *key = [NSNumber numberWithInteger:[task hash]];
        if(task.currentRequest) {
            httpData.requestHead = task.currentRequest.allHTTPHeaderFields;
        }
        @synchronized (self.httpDataDict) {
            [self.httpDataDict setObject:httpData forKey:key];
        }
    }
}

- (OBHttpData *)getHttpDataWithTask:(NSURLSessionTask *)task {
    OBHttpData *httpData = nil;
    if(task && self.httpDataDict){
        @synchronized (self.httpDataDict) {
            NSNumber *key = [NSNumber numberWithInteger:[task hash]];
            httpData = self.httpDataDict[key];
        }
    }
    return httpData;
}

- (void)removeHttpDataWithTask:(NSURLSessionTask *)task {
    if(task && self.httpDataDict){
        NSNumber *key = [NSNumber numberWithInteger:[task hash]];
        @synchronized (self.httpDataDict) {
            [self.httpDataDict removeObjectForKey:key];
        }
    }
}

- (void)addDataTask:(NSURLSessionTask *)task WithAddress:(NSString *)address {
    @synchronized(self.dataTaskDict) {
        [self.dataTaskDict setObject:task forKey:address];
    }
}

- (NSURLSessionTask *)taskFromAdress:(NSString *)address {
    @synchronized(self.dataTaskDict) {
        return [self.dataTaskDict objectForKey:address];
    }
}

- (void)removeTaskWithAdress:(NSString *)address {
    @synchronized(self.dataTaskDict) {
        [self.dataTaskDict removeObjectForKey:address];
    }
}

+ (void)httpErrorWithError:(NSError *)error HttpInfo:(OBHttpData *)httpData {
    if(!httpData || !error){
        return;
    }
    NSString *errorMsg = nil;
    switch (error.code) {
        case NSURLErrorCannotFindHost:
            errorMsg = @"CannotFindHost";
            break;
        case NSURLErrorTimedOut:
            errorMsg = @"TimedOut";
            break;
        case NSURLErrorCannotConnectToHost:
            errorMsg = @"CannotConnectToHost";
            break;
        default:
            errorMsg = @"UnKnow";
            break;
    }
    httpData.errorMsg = errorMsg;
}
@end
