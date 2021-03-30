//
//  OBCatonData.h
//  OBCollection
//
//  Created by orange on 2021/3/29.
//

#import "OBData.h"
NS_ASSUME_NONNULL_BEGIN

@interface OBCatonData : OBData
//页面名称
@property (nonatomic, copy) NSString *pageName;
//卡顿发生的时间
@property (nonatomic, copy) NSString *catonActionTime;
//卡顿持续时间
@property (nonatomic, assign) NSInteger spendTime;

@end

NS_ASSUME_NONNULL_END
