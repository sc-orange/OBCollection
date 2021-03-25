//
//  OBCatonObserver.h
//  KSCrash
//
//  Created by orange on 2021/3/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OBCatonObserver : NSObject
+ (OBCatonObserver *)sharedInstance;
- (void)startObserver;
- (void)stopObserver;

@end

NS_ASSUME_NONNULL_END
