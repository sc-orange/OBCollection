//
//  OBCollectionManager.h
//  ForORTest
//
//  Created by orange on 2020/11/23.
//

#import <Foundation/Foundation.h>
#import "OBConfigSetting.h"
#import "OBPageTrackerCollect.h"
#import "OBNSURLSessionCollect.h"

NS_ASSUME_NONNULL_BEGIN

@interface OBCollectionManager : NSObject

+ (OBCollectionManager *)shareInstance;

// 数据采集配置信息
@property (nonatomic, strong) OBConfigSetting *configSetting;
//页面轨迹采集类
@property (nonatomic, strong) OBPageTrackerCollect *pageTrackerCollect;
//http采集类
@property (nonatomic, strong) OBNSURLSessionCollect *httpCollect;

//打开关闭数据采集
- (void)startCollect;
- (void)stopCollect;

//根据采集配置设置具体功能
- (void)makeSettingWith:(NSDictionary *)setting;

@end

NS_ASSUME_NONNULL_END
