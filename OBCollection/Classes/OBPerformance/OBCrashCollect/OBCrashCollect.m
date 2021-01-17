//
//  OBCrashCollect.m
//  KSCrash
//
//  Created by orange on 2021/1/16.
//

#import "OBCrashCollect.h"
#import <KSCrash/KSCrash.h>
#import <KSCrash/KSCrashReportFilterAppleFmt.h>
#import "OBCrashData.h"
#import "NSString+OBDateFormat.h"
#import "NSDictionary+OBSafeDictionary.h"

static OBCrashCollect *_manager = nil;

@implementation OBCrashCollect

+ (OBCrashCollect *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[OBCrashCollect alloc] init];
    });
    return _manager;
}

- (instancetype)init {
    if (self = [super init]) {
        KSCrash *reporter = [KSCrash sharedInstance];
        [reporter install];
    }
    return self;
}

- (void)readCresh {
    KSCrash *reporter = [KSCrash sharedInstance];
    NSArray *reportIDs = reporter.reportIDs;
    if (!reportIDs.count) {
        return;
    }
    NSNumber *reportID = reportIDs.lastObject;
    NSDictionary *report = [reporter reportWithID:reportID];
    
    KSCrashReportFilterAppleFmt *filterAppleFmt = [KSCrashReportFilterAppleFmt filterWithReportStyle:KSAppleReportStyleSymbolicatedSideBySide];
    [filterAppleFmt filterReports:@[report] onCompletion:^(NSArray *filteredReports, BOOL completed, NSError *error) {
        if (completed && !error) {
            NSString *result = [filteredReports firstObject];
            if (!StringValid(result)) {
                return;
            }
            OBCrashData *crashData = OBCrashData.alloc.init;
            crashData.crashInfo = result;
            NSString *crashTime = [[report dictionaryForKey:@"report"] stringForKey:@"timestamp"];
            crashData.crashTime = [crashTime dateStringToFormat:@""];
            NSDictionary *systemInfoDic = [report dictionaryForKey:@"system"];
            crashData.appVersion = [systemInfoDic stringForKey:@"CFBundleShortVersionString"];
            NSString *appStartTime = [systemInfoDic stringForKey:@"app_start_time"];
            crashData.appStartTime = [appStartTime dateStringToFormat:@""];
            NSDictionary *memoryDic = [systemInfoDic dictionaryForKey:@"memory"];
            NSInteger memorySize = [memoryDic integerForKey:@"size"];
            crashData.memorySize = [NSString stringWithFormat:@"%ld",memorySize];
            NSInteger freeMemorySize = [memoryDic integerForKey:@"free"];
            crashData.freeMemorySize = [NSString stringWithFormat:@"%ld",freeMemorySize];
            NSString *machine = [systemInfoDic stringForKey:@"machine"];
            crashData.deviceName = [OBUtils deviceNameWithMachine:machine];
            crashData.systemVersion = [systemInfoDic stringForKey:@"system_version"];
            
//            crashData.pageTrack = [];
            
            //删除crash库中所有的信息
            [reporter deleteAllReports];
        }
    }];
}

@end
