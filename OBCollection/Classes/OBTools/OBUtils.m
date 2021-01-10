//
//  OBUtils.m
//  ForORTest
//
//  Created by orange on 2020/11/23.
//

#import "OBUtils.h"
#import <objc/runtime.h>

@implementation OBUtils

+ (SEL)makeNewSelectorFromSelector:(SEL)selector {
    return NSSelectorFromString([NSString stringWithFormat:@"_ob_swizzle_%x_%@",arc4random(),NSStringFromSelector(selector)]);
}

+ (void)replaceSelector:(SEL)originalSelector onClass:(Class)class withBlock:(id)block newSelector:(SEL)newSelector {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    if (!originalSelector) {
        return;
    }
    IMP implementation = imp_implementationWithBlock(block); //将block里面的方法转为IMP
    class_addMethod(class, newSelector, implementation, method_getTypeEncoding(originalMethod)); //给class添加新的方法
    Method newMethod = class_getInstanceMethod(class, newSelector); //获取新添加的方法
    method_exchangeImplementations(originalMethod, newMethod); //交换新旧方法
}

+ (NSString *)timeFromDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timgString = [dateFormatter stringFromDate:date];
    return timgString;
}

+ (NSInteger)currentSeconds {
    NSInteger seconds = [[NSDate date] timeIntervalSince1970] * 1000;
    return seconds;
}

+ (NSString *)currentTime {
    return [self timeFromDate:[NSDate date]];
}

@end
