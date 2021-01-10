//
//  OBNSURLSessionCollect.m
//  ForORTest
//
//  Created by orange on 2020/11/23.
//

#import "OBNSURLSessionCollect.h"
#import "OBUtils.h"
#import <objc/runtime.h>
#import <objc/message.h>

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
        NSLog(@"HTTP采集开启");
        self.hasCollected = YES;
        method_exchangeImplementations(self.original_Session, self.new_Session);
        method_exchangeImplementations(self.original_DataTaskWithRequest, self.new_DataTaskWithRequest);
        method_exchangeImplementations(self.original_DataTaskWithRequestCompletion, self.new_DataTaskWithRequestCompletion);
    }
}

- (void)stopCollect {
    if (self.hasCollected) {
        NSLog(@"HTTP采集关闭");
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
        // In iOS 7 resume lives in __NSCFLocalSessionTask
        // In iOS 8 resume lives in NSURLSessionTask
        // In iOS 9 resume lives in __NSCFURLSessionTask
        Class class = Nil;
        if (![[NSProcessInfo processInfo] respondsToSelector:@selector(operatingSystemVersion)]) {
            class = NSClassFromString([@[@"__", @"NSC", @"FLocalS", @"ession", @"Task"] componentsJoinedByString:@""]);
        } else if ([[NSProcessInfo processInfo] operatingSystemVersion].majorVersion < 9) {
            class = [NSURLSessionTask class];
        } else {
            class = NSClassFromString([@[@"__", @"NSC", @"FURLS", @"ession", @"Task"] componentsJoinedByString:@""]);
        }
        SEL originalSelector = @selector(resume);
        SEL swizzledSelector = [OBUtils makeNewSelectorFromSelector:originalSelector];
        void (^swizzleBlock)(NSURLSessionTask *) = ^(NSURLSessionTask *slf) {
            [weakSelf saveInfo:slf];
            ((void(*)(id, SEL))objc_msgSend)(slf, swizzledSelector);
        };
        [OBUtils replaceSelector:originalSelector onClass:class withBlock:swizzleBlock newSelector:swizzledSelector];
    });
}

- (void)saveInfo:(NSURLSessionTask *)task {
    
}

@end
