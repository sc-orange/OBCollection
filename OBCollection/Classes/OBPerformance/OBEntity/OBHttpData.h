//
//  OBHttpData.h
//  OBCollection
//
//  Created by orange on 2021/1/10.
//

#import "OBData.h"
NS_ASSUME_NONNULL_BEGIN

@interface OBHttpData : OBData<NSCopying>
@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) NSDictionary *requestHead;
@property (nonatomic, assign) NSInteger requestStartSeconds;
@property (nonatomic, copy) NSString *requestStartTime;
@property (nonatomic, copy) NSString *responseTime;
@property (nonatomic, assign) NSInteger responseSpacing;
@property (nonatomic, copy) NSString *responseStatusCode;
@property (nonatomic, strong) NSDictionary *responseHeader;

@property (nonatomic, copy) NSString *errorMsg;

- (NSInteger)ob_responseTime;
@end

NS_ASSUME_NONNULL_END
