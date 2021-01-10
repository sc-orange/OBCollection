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

- (void)removeHttpDataWithTask:(NSURLSessionTask *)task;

- (void)addDataTask:(NSURLSessionTask *)task WithAddress:(NSString *)address;

- (NSURLSessionTask *)taskFromAdress:(NSString *)address;

- (void)removeTaskWithAdress:(NSString *)address;

+ (void)httpErrorWithError:(NSError *)error HttpInfo:(OBHttpData *)httpData;

@end

NS_ASSUME_NONNULL_END
