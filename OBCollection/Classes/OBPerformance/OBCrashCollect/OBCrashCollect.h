//
//  OBCrashCollect.h
//  KSCrash
//
//  Created by orange on 2021/1/16.
//

#import <Foundation/Foundation.h>
#import "OBCrashData.h"

NS_ASSUME_NONNULL_BEGIN

@interface OBCrashCollect : NSObject

+ (OBCrashCollect *)sharedInstance;

- (void)startCollect;
- (void)stopCollect;

- (void)readCreshData:(void(^)(OBCrashData *crashData))complete;

@end

NS_ASSUME_NONNULL_END
