//
//  OBWebViewCollect.m
//  OBCollection
//
//  Created by orange on 2021/4/4.
//

#import "OBWebViewCollect.h"
#import <WebKit/WebKit.h>
#import <objc/runtime.h>
#import <objc/message.h>

@interface NewScriptMessageHandler: NSObject <WKScriptMessageHandler>

@end

@implementation NewScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"jsToOcNoPrams"]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"我是HookWebView的弹窗" message:@"不带参数" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }])];
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
    }
}
@end

#pragma mark - WKWebView
@interface WKWebView (OBWebViewCollect)
- (instancetype)newInitWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration;

@end

@implementation WKWebView (OBWebViewCollect)
- (instancetype)newInitWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration {
    
    WKUserContentController *userContentController = configuration.userContentController;
    if (!userContentController) {
        userContentController = [[WKUserContentController alloc] init];
    }
    
    NewScriptMessageHandler *scriptMessageHandle = [[NewScriptMessageHandler alloc] init];
    [userContentController removeScriptMessageHandlerForName:@"jsToOcNoPrams"];
    [userContentController addScriptMessageHandler:scriptMessageHandle name:@"jsToOcNoPrams"];
    
    configuration.userContentController = userContentController;
    return [self newInitWithFrame:frame configuration:configuration];
}

@end

@interface OBWebViewCollect ()
@property(nonatomic, assign) BOOL hasCollected;

@property (nonatomic, assign) Method original_InitWithFrameConfiguration;
@property (nonatomic, assign) Method new_InitWithFrameConfiguration;
@end

@implementation OBWebViewCollect

- (instancetype)init {
    if (self = [super init]) {
        self.original_InitWithFrameConfiguration = class_getInstanceMethod(NSClassFromString(@"WKWebView"), @selector(initWithFrame:configuration:));
        self.new_InitWithFrameConfiguration = class_getInstanceMethod(NSClassFromString(@"WKWebView"), @selector(newInitWithFrame:configuration:));
    }
    return self;
}

- (void)startWebViewCollect {
    if (!self.hasCollected) {
        [OBLog print:@"WebView采集：开启成功"];
        self.hasCollected = YES;
        method_exchangeImplementations(self.original_InitWithFrameConfiguration, self.new_InitWithFrameConfiguration);
    }
}

- (void)stopWebViewCollect {
    if (self.hasCollected) {
        [OBLog print:@"WebView采集关闭"];
        self.hasCollected = NO;
        method_exchangeImplementations(self.original_InitWithFrameConfiguration, self.new_InitWithFrameConfiguration);
    }
}
@end
