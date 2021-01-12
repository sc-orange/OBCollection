//
//  OBData.h
//  ForORTest
//
//  Created by orange on 2020/11/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OBData : NSObject

- (NSString *)description;

- (void)appendString:(NSString *)string To:(NSMutableString *)muString;
- (void)appendIntger:(NSInteger)intger To:(NSMutableString *)muString;

@end

NS_ASSUME_NONNULL_END
