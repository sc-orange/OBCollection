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

//创建一个遵循 NSURLSession 里的协议的类，并实现协议里的方法。（注意：要尽量实现 NSURLSession 里面代理方法，不然交换方法后这里不实现的代理方法外界也无法实现。目前只实现了3个常用的）
@interface URLSessionNewDelegate : NSObject<NSURLSessionDataDelegate> {
    id _delegate;
}
@end

@implementation URLSessionNewDelegate

- (id)initWithDelegate:(id)delegate {
    if (self = [super init]) {
        if (delegate) {
            _delegate = delegate;
        }
    }
    return self;
}

- (void)dealloc {
    _delegate = nil;
}

#pragma mark - NSURLSession Delegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    if (_delegate && [_delegate respondsToSelector:@selector(URLSession:task:didCompleteWithError:)]) {
        [_delegate URLSession:session dataTask:dataTask didReceiveData:data];
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    if (_delegate && [_delegate respondsToSelector:@selector(URLSession:dataTask:didReceiveResponse:completionHandler:)]) {
        [_delegate URLSession:session dataTask:dataTask didReceiveResponse:response completionHandler:completionHandler];
    } else {
        if (completionHandler) {
            completionHandler(NSURLSessionResponseAllow);
        }
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    OBHttpData *httpData = [[OBNSURLSessionCollectManager sharedInstance] getHttpDataWithTask:task];
    if(httpData) {
        OBHttpData *newData = [httpData copy];
        newData.responseTime = [OBUtils currentTime];
        newData.responseSpacing = [httpData ob_responseTime];
        
        if([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
            
            int statusCode = (int)[response statusCode];
            newData.responseStatusCode = [NSString stringWithFormat:@"%d", statusCode];
            
            NSDictionary *headers = [[response allHeaderFields] copy];
            newData.responseHeader = headers;
        }
        
        if (error) {
            [OBNSURLSessionCollectManager httpErrorWithError:error HttpInfo:newData];
        }
        //http采集
        [[OBCollectionManager sharedInstance] addCollectionData:newData];
    }
    [[OBNSURLSessionCollectManager sharedInstance] removeHttpDataWithTask:task];
    
    //实现完协议方法后再调用外部实现协议的方法
    if (_delegate && [_delegate respondsToSelector:@selector(URLSession:task:didCompleteWithError:)]) {
        [_delegate URLSession:session task:task didCompleteWithError:error];
    }
}


@end

#pragma mark - NSURLSession
@interface NSURLSession (OBNSURLSessionCollect)

+ (NSURLSession *)newSessionWithConfiguration:(NSURLSessionConfiguration *)configuration delegate:(id<NSURLSessionDelegate>)delegate delegateQueue:(NSOperationQueue *)queue;

- (NSURLSessionDataTask *)newSessionDataTaskWithRequest:(NSURLRequest *)request;

- (NSURLSessionDataTask *)newDataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))completionHandler;

@end

@implementation NSURLSession (OBNSURLSessionCollect)

+ (NSURLSession *)newSessionWithConfiguration:(NSURLSessionConfiguration *)configuration delegate:(id<NSURLSessionDelegate>)delegate delegateQueue:(NSOperationQueue *)queue {
    URLSessionNewDelegate *newDelegate = [[URLSessionNewDelegate alloc] initWithDelegate:delegate];
    return [self newSessionWithConfiguration:configuration delegate:newDelegate delegateQueue:queue];
}

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

                    if([response isKindOfClass:[NSHTTPURLResponse class]]) {
                        int statusCode = (int)[(NSHTTPURLResponse *)response statusCode];
                        newData.responseStatusCode = [NSString stringWithFormat:@"%d", statusCode];

                        NSDictionary *headers = [[(NSHTTPURLResponse *)response allHeaderFields] copy];
                        newData.responseHeader = headers;
                    }

                    if (error) {
                        [OBNSURLSessionCollectManager httpErrorWithError:error HttpInfo:newData];
                    }

                    //http采集
                    [[OBCollectionManager sharedInstance] addCollectionData:newData];
                }
                [[OBNSURLSessionCollectManager sharedInstance] removeHttpDataWithTask:dataTask];
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
@property(nonatomic, assign) BOOL hasCollected;
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
        self.new_Session = class_getClassMethod(NSClassFromString(@"NSURLSession"), @selector(newSessionWithConfiguration:delegate:delegateQueue:));

        self.original_DataTaskWithRequest = class_getInstanceMethod(NSClassFromString(@"NSURLSession"), @selector(dataTaskWithRequest:));
        self.new_DataTaskWithRequest = class_getInstanceMethod(NSClassFromString(@"NSURLSession"), @selector(newSessionDataTaskWithRequest:));

        self.original_DataTaskWithRequestCompletion = class_getInstanceMethod(NSClassFromString(@"NSURLSession"), @selector(dataTaskWithRequest:completionHandler:));
        self.new_DataTaskWithRequestCompletion = class_getInstanceMethod(NSClassFromString(@"NSURLSession"), @selector(newDataTaskWithRequest:completionHandler:));
        
    }
    return self;
}

- (void)startCollect {
    if (!self.hasCollected) {
        [OBLog print:@"HTTP采集：开启成功"];
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
