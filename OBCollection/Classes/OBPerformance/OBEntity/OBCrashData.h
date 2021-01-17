//
//  OBCrashData.h
//  OBCollection
//
//  Created by orange on 2021/1/16.
//

#import "OBData.h"

NS_ASSUME_NONNULL_BEGIN

@interface OBCrashData : OBData
@property (nonatomic, copy) NSString *crashInfo;
@property (nonatomic, copy) NSString *crashTime;
@property (nonatomic, copy) NSString *appVersion;
@property (nonatomic, copy) NSString *appStartTime;
@property (nonatomic, copy) NSString *systemVersion;
@property (nonatomic, copy) NSString *memorySize;
@property (nonatomic, copy) NSString *freeMemorySize;
@property (nonatomic, copy) NSString *deviceName;
@property (nonatomic, copy) NSString *pageTrack;
@property (nonatomic, copy) NSString *lastPage;

@end

NS_ASSUME_NONNULL_END
