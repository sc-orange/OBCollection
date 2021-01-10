//
//  OBNSURLSessionCollect.m
//  ForORTest
//
//  Created by orange on 2020/11/23.
//

#import "OBNSURLSessionCollect.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "OBNSURLSessionCollectManager.h"
#import <malloc/malloc.h>
#import "OBCollectionManager.h"

#pragma mark - NSURLSession
@interface NSURLSession (OBNSURLSessionCollect)

//+ (NSURLSession *)newSessionWithConfiguration:(NSURLSessionConfiguration *)configuration delegate:(id<NSURLSessionDelegate>)delegate delegateQueue:(NSOperationQueue *)queue;

- (NSURLSessionDataTask *)newSessionDataTaskWithRequest:(NSURLRequest *)request;

- (NSURLSessionDataTask *)newDataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))completionHandler;

@end

@implementation NSURLSession (OBNSURLSessionCollect)

//+ (NSURLSession *)newSessionWithConfiguration:(NSURLSessionConfiguration *)configuration delegate:(id<NSURLSessionDelegate>)delegate delegateQueue:(NSOperationQueue *)queue {
//    re
//}

- (NSURLSessionDataTask *)newSessionDataTaskWithRequest:(NSURLRequest *)request {
    NSURLRequest *req = [self handleRequest:request];
    return [self newSessionDataTaskWithRequest:req];
}

- (NSURLSessionDataTask *)newDataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))completionHandler {
    
    if (completionHandler) {
        NSURLRequest *req = [self handleRequest:request];
        __block NSString *address = [[NSString alloc] initWithFormat:@"%p", req];
        void(^newCompletionHandle)(NSData *data, NSURLResponse *response, NSError *error) = ^(NSData *data, NSURLResponse *response, NSError *error) {
            if (!malloc_zone_from_ptr(CFBridgingRetain(address))) {
                if (completionHandler) {
                    completionHandler(data, response, error);
                }
                return;
            }
            NSURLSessionTask *dataTask = [[OBNSURLSessionCollectManager sharedInstance] taskFromAdress:address];
            if (malloc_zone_from_ptr(CFBridgingRetain(self)) && dataTask) {
                OBHttpData *httpData = [[OBNSURLSessionCollectManager sharedInstance] getHttpDataWithTask:dataTask];
                if (httpData) {
                    OBHttpData *newData = [httpData copy];
                    newData.responseTime = [OBUtils currentTime];
                    newData.responseSpacing = [newData ob_responseTime];

                    int statusCode = (int)[(NSHTTPURLResponse *)response statusCode];
                    newData.responseStatusCode = [NSString stringWithFormat:@"%d", statusCode];

                    NSDictionary *headers = [[(NSHTTPURLResponse *)response allHeaderFields] copy];
                    newData.responseHeader = headers;

                    if (error) {
                        [OBNSURLSessionCollectManager httpErrorWithError:error HttpInfo:newData];
                    }

                    //http采集
                    [[OBCollectionManager sharedInstance] addCollectionData:newData];

                    [[OBNSURLSessionCollectManager sharedInstance] removeHttpDataWithTask:dataTask];
                }
            }

            [[OBNSURLSessionCollectManager sharedInstance] removeTaskWithAdress:address];

            if (completionHandler) {
                completionHandler(data, response, error);
            }
        };
        NSURLSessionDataTask *task = [self newDataTaskWithRequest:req completionHandler:newCompletionHandle];
        [[OBNSURLSessionCollectManager sharedInstance] addDataTask:task WithAddress:address];
        return task;
    } else {
        return [self newDataTaskWithRequest:request completionHandler:completionHandler];
    }
}

//标记要采集的信息
- (NSURLRequest *)handleRequest:(NSURLRequest *)request {
    NSMutableURLRequest *obRequest = [request mutableCopy];
    [obRequest setValue:@"orangeRequest" forHTTPHeaderField:@"orangeRequest"];
    return obRequest;
}

@end

@interface OBNSURLSessionCollect()
@property(nonatomic) BOOL hasCollected;
@property (nonatomic,assign) Method original_Session;
@property (nonatomic,assign) Method new_Session;

@property (nonatomic,assign) Method original_DataTaskWithRequest;
@property (nonatomic,assign) Method new_DataTaskWithRequest;

@property (nonatomic,assign) Method original_DataTaskWithRequestCompletion;
@property (nonatomic,assign) Method new_DataTaskWithRequestCompletion;
@end

@implementation OBNSURLSessionCollect

- (instancetype)init {
    if (self = [super init]) {
        self.original_Session = class_getClassMethod(NSClassFromString(@"NSURLSession"), @selector(sessionWithConfiguration:delegate:delegateQueue:));
//        self.new_Session = class_getClassMethod(NSClassFromString(@"NSURLSession"), @selector(newSessionWithConfiguration:delegate:delegateQueue:));

        self.original_DataTaskWithRequest = class_getInstanceMethod(NSClassFromString(@"NSURLSession"), @selector(dataTaskWithRequest:));
        self.new_DataTaskWithRequest = class_getInstanceMethod(NSClassFromString(@"NSURLSession"), @selector(newSessionDataTaskWithRequest:));

        self.original_DataTaskWithRequestCompletion = class_getInstanceMethod(NSClassFromString(@"NSURLSession"), @selector(dataTaskWithRequest:completionHandler:));
        self.new_DataTaskWithRequestCompletion = class_getInstanceMethod(NSClassFromString(@"NSURLSession"), @selector(newDataTaskWithRequest:completionHandler:));
        
    }
    return self;
}

- (void)startCollect {
    if (!self.hasCollected) {
        [OBLog print:@"HTTP采集开启"];
        self.hasCollected = YES;
        method_exchangeImplementations(self.original_Session, self.new_Session);
        method_exchangeImplementations(self.original_DataTaskWithRequest, self.new_DataTaskWithRequest);
        method_exchangeImplementations(self.original_DataTaskWithRequestCompletion, self.new_DataTaskWithRequestCompletion);
        [self exchangeResume];
    }
}

- (void)stopCollect {
    if (self.hasCollected) {
        [OBLog print:@"HTTP采集关闭"];
        self.hasCollected = NO;
        method_exchangeImplementations(self.new_Session, self.original_Session);
        method_exchangeImplementations(self.new_DataTaskWithRequest, self.original_DataTaskWithRequest);
        method_exchangeImplementations(self.new_DataTaskWithRequestCompletion, self.original_DataTaskWithRequestCompletion);
    }
}

- (void)exchangeResume {
    __weak typeof(self) weakSelf = self;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = Nil;
        if (![NSProcessInfo.processInfo respondsToSelector:@selector(operatingSystemVersion)]) {
            // iOS ... 7
            class = NSClassFromString(@"__NSCFLocalSessionTask");
        } else {
            NSInteger majorVersion = NSProcessInfo.processInfo.operatingSystemVersion.majorVersion;
            if (majorVersion < 9 || majorVersion >= 14) {
                // iOS 8 or iOS 14+
                class = [NSURLSessionTask class];
            } else {
                // iOS 9 ... 13
                class = NSClassFromString(@"__NSCFURLSessionTask");
            }
        }
        SEL originalSelector = @selector(resume);
        SEL swizzledSelector = [OBUtils makeNewSelectorFromSelector:originalSelector];
        void (^swizzleBlock)(NSURLSessionTask *) = ^(NSURLSessionTask *slf) {
            NSDictionary *dict = slf.currentRequest.allHTTPHeaderFields;
            if (self.hasCollected && dict[@"orangeRequest"]) {
                [weakSelf saveInfo:slf];
            }
            ((void(*)(id, SEL))objc_msgSend)(slf, swizzledSelector);
        };
        [OBUtils replaceSelector:originalSelector onClass:class withBlock:swizzleBlock newSelector:swizzledSelector];
    });
}

- (void)saveInfo:(NSURLSessionTask *)task {
    [[OBNSURLSessionCollectManager sharedInstance] addHttpDataWithTask:task];
}

@end
