//
//  OBCrashCollect.m
//  KSCrash
//
//  Created by orange on 2021/1/16.
//

#import "OBCrashCollect.h"
#import <KSCrash/KSCrash.h>
#import <KSCrash/KSCrashReportFilterAppleFmt.h>

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
            if (result) {
                NSLog(@"%@", result);
            }
            //删除crash库中所有的信息
            [reporter deleteAllReports];
        }
    }];
}

@end
