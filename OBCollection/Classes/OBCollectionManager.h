//
//  OBCollectionManager.h
//  ForORTest
//
//  Created by orange on 2020/11/23.
//

#import <Foundation/Foundation.h>
#import "OBConfigSetting.h"
#import "OBData.h"
#import "OBHttpData.h"
#import "OBCrashData.h"
#import "OBCatonData.h"
#import "OBPageTrackerCollect.h"
#import "OBNSURLSessionCollect.h"
#import "OBCrashCollect.h"
#import "OBCatonObserver.h"

NS_ASSUME_NONNULL_BEGIN

@interface OBCollectionManager : NSObject

+ (OBCollectionManager *)sharedInstance;

// 数据采集配置信息
@property (nonatomic, strong) OBConfigSetting *configSetting;
//页面轨迹采集类
@property (nonatomic, strong) OBPageTrackerCollect *pageTrackerCollect;
//http采集类
@property (nonatomic, strong) OBNSURLSessionCollect *httpCollect;
//Crash采集类
@property (nonatomic, strong) OBCrashCollect *crashCollect;
//卡顿采集类
@property (nonatomic, strong) OBCatonObserver *catonObserver;


//HTTP
@property (nonatomic, strong) NSMutableArray<OBHttpData *> *httpDataArray;
@property (nonatomic, strong) NSMutableArray<OBHttpData *> *httpErrorDataArray;
//Crash
@property (nonatomic, strong) OBCrashData *crashData;
//Caton
@property (nonatomic, strong) NSMutableArray<OBCatonData *> *catonDataArray;



//打开关闭数据采集
- (void)startCollect;
- (void)stopCollect;

//是否打印log
+ (void)openLog:(BOOL)open;

//采集数据
- (void)addCollectionData:(OBData *)data;

@end

NS_ASSUME_NONNULL_END
