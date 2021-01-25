//
//  OBCrashData.m
//  OBCollection
//
//  Created by orange on 2021/1/16.
//

#import "OBCrashData.h"

@implementation OBCrashData

- (NSString *)description {
    NSMutableString *dataString = [NSMutableString stringWithFormat:@""];
    [self appendString:[NSString stringWithFormat:@"崩溃时间:%@",self.crashTime] To:dataString];
    [self appendString:[NSString stringWithFormat:@"APP版本号:%@",self.appVersion] To:dataString];
    [self appendString:[NSString stringWithFormat:@"APP启动时间:%@",self.appStartTime] To:dataString];
    [self appendString:[NSString stringWithFormat:@"设备iOS版本号:%@",self.systemVersion] To:dataString];
    [self appendString:[NSString stringWithFormat:@"设备内存:%@",self.memorySize] To:dataString];
    [self appendString:[NSString stringWithFormat:@"设备可用内存:%@",self.freeMemorySize] To:dataString];
    [self appendString:[NSString stringWithFormat:@"设备名:%@",self.deviceName] To:dataString];
    [self appendString:[NSString stringWithFormat:@"页面轨迹:%@",self.pageTrack] To:dataString];
    [self appendString:[NSString stringWithFormat:@"崩溃页面:%@",self.lastPage] To:dataString];
    return dataString;
}

@end
