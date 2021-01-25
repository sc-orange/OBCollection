//
//  OBCrashCollect.m
//  KSCrash
//
//  Created by orange on 2021/1/16.
//

#import "OBCrashCollect.h"
#import <KSCrash/KSCrash.h>
#import <KSCrash/KSCrashReportFilterAppleFmt.h>
#import "NSString+OBDateFormat.h"
#import "NSDictionary+OBSafeDictionary.h"

static OBCrashCollect *_manager = nil;

@interface OBCrashCollect ()
@property (nonatomic, assign) BOOL isStarted;
@property (nonatomic, strong) NSArray *pageArray;
@end

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
        self.pageArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"ob_page_data"];
    }
    return self;
}

- (void)startCollect {
    if (!_isStarted) {
        _isStarted = YES;
        
        KSCrash *reporter = [KSCrash sharedInstance];
        BOOL isSuccess = [reporter install];
        if (isSuccess) {
            [OBLog print:@"Crash采集：开启成功"];
        } else {
            [OBLog print:@"Crash采集：开启失败"];
        }
    }
}

- (void)stopCollect {
    if(_isStarted){
        _isStarted = NO;
    }
}

- (void)readCreshData:(void(^)(OBCrashData *crashData))complete {
    KSCrash *reporter = [KSCrash sharedInstance];
    NSArray *reportIDs = reporter.reportIDs;
    if (!reportIDs.count) {
        complete(nil);
        return;
    }
    NSNumber *reportID = reportIDs.lastObject;
    NSDictionary *report = [reporter reportWithID:reportID];
    
    KSCrashReportFilterAppleFmt *filterAppleFmt = [KSCrashReportFilterAppleFmt filterWithReportStyle:KSAppleReportStyleSymbolicatedSideBySide];
    [filterAppleFmt filterReports:@[report] onCompletion:^(NSArray *filteredReports, BOOL completed, NSError *error) {
        if (completed && !error) {
            NSString *result = [filteredReports firstObject];
            if (!StringValid(result)) {
                complete(nil);
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
            crashData.memorySize = [NSString stringWithFormat:@"%ldMB",memorySize / 1024 / 1024];
            NSInteger freeMemorySize = [memoryDic integerForKey:@"free"];
            crashData.freeMemorySize = [NSString stringWithFormat:@"%ldMB",freeMemorySize / 1024 / 1024];
            NSString *machine = [systemInfoDic stringForKey:@"machine"];
            crashData.deviceName = [OBUtils deviceNameWithMachine:machine];
            crashData.systemVersion = [systemInfoDic stringForKey:@"system_version"];
            crashData.pageTrack = self.pageArray.count > 0 ? [self.pageArray componentsJoinedByString:@"-"] : @"";
            crashData.lastPage = self.pageArray.count > 0 ? self.pageArray.lastObject : @"";
            //删除crash库中所有的信息
            [reporter deleteAllReports];
            if (complete) {
                complete(crashData);
            }
        }else {
            if (complete) {
                complete(nil);
            }
        }
    }];
}

@end
