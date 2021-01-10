//
//  OBLog.h
//  OBCollection
//
//  Created by orange on 2021/1/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OBLog : NSObject

+ (void)canOpenLog:(BOOL)open;

+ (void)print:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);

@end

NS_ASSUME_NONNULL_END
