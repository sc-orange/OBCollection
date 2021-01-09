//
//  OBPageTrackerCollect.h
//  ForORTest
//
//  Created by orange on 2020/11/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OBPageTrackerCollect : NSObject

@property (nonatomic, assign) BOOL isEnabled;
@property (nonatomic, strong) NSMutableArray<NSString *> *pageTrackData;

@end

NS_ASSUME_NONNULL_END
