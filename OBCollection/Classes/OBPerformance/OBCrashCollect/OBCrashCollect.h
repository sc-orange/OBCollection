//
//  OBCrashCollect.h
//  KSCrash
//
//  Created by orange on 2021/1/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OBCrashCollect : NSObject

+ (OBCrashCollect *)sharedInstance;

- (void)readCresh;

@end

NS_ASSUME_NONNULL_END
