//
//  OBConfigSetting.h
//  ForORTest
//
//  Created by orange on 2020/11/23.
//

#define OBPageTrackSetting @"OBPageTrackSetting"
#define OBCrashSetting @"OBCrashSetting"
#define OBHttpSetting @"OBHttpSetting"
#define OBWebViewSetting @"OBWebViewSetting"
#define OBCatonSetting @"OBCatonSetting"

#import <Foundation/Foundation.h>
#import "NSDictionary+OBSafeDictionary.h"

NS_ASSUME_NONNULL_BEGIN

@interface OBConfigSetting : NSObject
// 页面轨迹采集开关
@property (nonatomic, assign) BOOL pageTrackSwitch;
// 崩溃采集开关
@property (nonatomic, assign) BOOL crashSwitch;
// http采集开关
@property (nonatomic, assign) BOOL httpSwitch;
// webView采集开关
@property (nonatomic, assign) BOOL webViewSwitch;
// 卡顿采集开关
@property (nonatomic, assign) BOOL catonSwitch;

//获取本地配置信息
+ (NSDictionary *)readLocalSetting;
//保存配置信息
+ (void)saveLocalSetting:(NSDictionary *)setting;
//刷新配置信息
+ (void)refreshLocalSetting:(NSDictionary *)setting;
//配置设置
- (void)setConfigSetting:(NSDictionary *)setting;


@end

NS_ASSUME_NONNULL_END
