//
//  OBNSURLSessionCollectManager.h
//  ForORTest
//
//  Created by orange on 2020/11/28.
//

#import <Foundation/Foundation.h>
#import "OBHttpData.h"

NS_ASSUME_NONNULL_BEGIN

@interface OBNSURLSessionCollectManager : NSObject

+ (OBNSURLSessionCollectManager *)sharedInstance;

- (void)addHttpDataWithTask:(NSURLSessionTask *)task;

- (OBHttpData *)getHttpDataWithTask:(NSURLSessionTask *)task;

@end

NS_ASSUME_NONNULL_END
