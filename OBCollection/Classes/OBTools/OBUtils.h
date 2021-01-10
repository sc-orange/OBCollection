//
//  OBUtils.h
//  ForORTest
//
//  Created by orange on 2020/11/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OBUtils : NSObject
//生成新的SEL
+ (SEL)makeNewSelectorFromSelector:(SEL)selector;
//交换方法
+ (void)replaceSelector:(SEL)originalSelector onClass:(Class)class withBlock:(id)block newSelector:(SEL)newSelector;
//date转string
+ (NSString *)timeFromDate:(NSDate *)date;
//获取当前时间戳
+ (NSInteger)currentSeconds;
//获取当前时间
+ (NSString *)currentTime;
@end

NS_ASSUME_NONNULL_END
