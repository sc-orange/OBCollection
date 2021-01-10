//
//  OBHttpData.h
//  OBCollection
//
//  Created by orange on 2021/1/10.
//

#import "OBData.h"

NS_ASSUME_NONNULL_BEGIN

@interface OBHttpData : OBData
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *requestHead;
@end

NS_ASSUME_NONNULL_END
