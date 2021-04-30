//
//  OBPageTrackerCollect.m
//  ForORTest
//
//  Created by orange on 2020/11/23.
//

#import "OBPageTrackerCollect.h"
#import <objc/message.h>

@implementation OBPageTrackerCollect

- (instancetype)init {
    self = [super init];
    if (self) {
        _pageTrackData = [NSMutableArray array];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"ob_page_data"];
    }
    return self;
}

- (void)setIsEnabled:(BOOL)isEnabled {
    _isEnabled = isEnabled;
    if (isEnabled) {
        [self getPageTrack];
    }
}

- (void)getPageTrack {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self ob_viewDidLoad];
    });
}

- (void)ob_viewDidLoad {
    __weak typeof(self)weakself = self;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = NSClassFromString(@"UIViewController");
        if (class) {
            SEL originalSelector = NSSelectorFromString(@"viewDidLoad");
            SEL newSelector = [OBUtils makeNewSelectorFromSelector:originalSelector];
            
            void (^swizzledBlock)(Class) = ^ void(Class cls) {
                NSString *clsName = NSStringFromClass([cls class]);
                ((void (*)(id, SEL))objc_msgSend)(cls, newSelector);
                if (weakself.isEnabled && [self canSave:clsName]) {
                    [weakself savePageInfo:clsName];
                }
            };
            [OBUtils replaceSelector:originalSelector onClass:class withBlock:swizzledBlock newSelector:newSelector];
        }
    });
}

- (BOOL)canSave:(NSString *)page {
    NSArray *sysPage = @[@"OBTabBarController", @"UINavigationController", @"UIInputWindowController", @"UIEditingOverlayViewController"];
    return ![sysPage containsObject:page];
}

- (void)savePageInfo:(NSString *)name {
    if (!self.pageTrackData) return;
    [self.pageTrackData addObject:name];
    if(self.pageTrackData.count > 20){
        [self.pageTrackData removeObjectAtIndex:0];
    }
    [[NSUserDefaults standardUserDefaults] setObject:[self.pageTrackData copy] forKey:@"ob_page_data"];
}

@end
