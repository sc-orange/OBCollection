//
//  OBCatonObserver.m
//  KSCrash
//
//  Created by orange on 2021/3/25.
//

#import "OBCatonObserver.h"

#define CatonObserverTime 1000 //卡顿监测时间

static OBCatonObserver *_manager = nil;

@interface OBCatonObserver () {
//    // 卡顿次数 超时次数 用于多次短时间卡顿检测
//    int timeoutCount;
//    // runloop观察者
//    CFRunLoopObserverRef _observer;
//    // 信号量
//    dispatch_semaphore_t _semaphore;
//    // runloop状态
//    CFRunLoopActivity _activity;
//    // 卡顿实体类
//    CTCarltonEntity *_entity;
//
//    // runloop状态为kCFRunLoopBeforeSources 且信号量等待超时 用于统计时间戳
//    long long _sTime;
//    // runloop状态为kCFRunLoopBeforeSources 自动加1 防止单词卡顿统计多次，造成卡顿检测指标时间不准
//    NSInteger _runloopId;
//
//    int _adrLantency;
//    int _flag;
}
@end

@implementation OBCatonObserver

+ (OBCatonObserver *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[OBCatonObserver alloc] init];
    });
    return _manager;
}

//- (instancetype)init {
//    if (self = [super init]) {
//        _sTime = 0;
//        _runloopId = 0;
//        timeoutCount = 0;
//    }
//    return self;
//}

- (void)startObserver {
//    _adrLantency = 300;
//    _flag = 0;
//
//    if ([saPfWatchManager shareInstance].configSetting && [saPfWatchManager shareInstance].configSetting.adrTimeLatency > 0) {
//        _adrLantency = [saPfWatchManager shareInstance].configSetting.adrTimeLatency;
//
//        if (_adrLantency * 5 > LANTENCY) {
//            _adrLantency = _adrLantency * 5;
//            _flag = 1;
//        }
//    }
//
//    if (_observer) {
//        return;
//    }
//
//    // semaphore 创建信号量
//    if (!_semaphore) {
//        _semaphore = dispatch_semaphore_create(1);
//    }
//
//    /*
//     typedef CF_OPTIONS(CFOptionFlags, CFRunLoopActivity) {
//         kCFRunLoopEntry = (1UL << 0),               // 即将进入Loop：1
//         kCFRunLoopBeforeTimers = (1UL << 1),        // 即将处理Timer：2
//         kCFRunLoopBeforeSources = (1UL << 2),       // 即将处理Source：4
//         kCFRunLoopBeforeWaiting = (1UL << 5),       // 即将进入休眠：32
//         kCFRunLoopAfterWaiting = (1UL << 6),        // 即将从休眠中唤醒：64
//         kCFRunLoopExit = (1UL << 7),                // 即将从Loop中退出：128
//         kCFRunLoopAllActivities = 0x0FFFFFFFU       // 监听全部状态改变
//     };
//     */
//
//    // 注册runloop状态观察 回调方式
//
//    _observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
//        @synchronized (self) {
//            self->_activity = activity;
//        }
//        switch (activity) {
//            case kCFRunLoopEntry:
//                break;
//            case kCFRunLoopBeforeTimers:
//                break;
//            case kCFRunLoopBeforeSources:  //即将处理Source
//                @synchronized (self) {
//                    self->_runloopId += 1;
//                    if (self->_runloopId > 99) {
//                        self->_runloopId = 0;
//                    }
//                }
//                break;
//            case kCFRunLoopBeforeWaiting:  //即将进入休眠
//                if (_sTime != 0) {
//                    @synchronized (self) {
//                        long long t = [CTUtils currentTimeMillis];
//
//                        [CTLog print:@"runloop calback runloopId = %ld, 卡顿持续时间 = %lld, _sTime = %lld",(long)self->_runloopId,t - _sTime, _sTime];
//                        _entity.spendTime = t - _sTime;
//                        // 前台页面
//                        NSArray *pageArray = [[[saPfWatchManager shareInstance] crashHookAgent] getPageData];
//                        NSString *topPage = [pageArray firstObject];
//                        NSRange range = [topPage rangeOfString:@"@"];
//                        if (range.location != NSNotFound) {
//                            topPage = [topPage substringFromIndex:range.location+1];
//                        }
//                        _entity.topPage = topPage;
//                        _entity.pageTrace = [pageArray componentsJoinedByString:@";"];
//                        [[saPfWatchManager shareInstance] addCollectionData:_entity];
//                        _sTime = 0;
//                        _entity = nil;
//                        self->_runloopId = 0;
//                    }
//                }
//                break;
//            case kCFRunLoopAfterWaiting:
//                break;
//            case kCFRunLoopExit:
//                break;
//            default:
//                break;
//        }
//
//        dispatch_semaphore_t bSemaphore = self->_semaphore;
//        dispatch_semaphore_signal(bSemaphore);
//    });
//
//    // 监听主线程
//    CFRunLoopAddObserver(CFRunLoopGetMain(), _observer, kCFRunLoopCommonModes);
//
//    // 在子线程监控时长 开启一个子线程 该线程在app运行期间一直运行
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSInteger loopId = 0;
//        while (YES) {
//            //1、 设置等待时间3秒，如果超过3秒，则超时，主线程卡顿
//            //2、 设置超时时间为lantency / 5，如果连续5次超时，主线程卡顿
//
//            //number不为0：超时，继续往下执行
//            NSInteger number = dispatch_semaphore_wait(_semaphore, dispatch_time(DISPATCH_TIME_NOW, _adrLantency * NSEC_PER_MSEC));;
//            if (number != 0) {
//                if (!_observer) {
//                    timeoutCount = 0;
//                    return ;
//                }
//
//                //主线程执行任务
//                if (self->_activity == kCFRunLoopBeforeSources || self->activity == kCFRunLoopAfterWaiting) {
//
//                    // 连续发生5次，则认为是卡顿
//                    if (_flag == 0) {
//                        if (++timeoutCount < 5) {
//                            continue;
//                        }
//                    }
//
//                    if (loopId != self->_runloopId) {
//                        @synchronized (self) {
//                            loopId = self->_runloopId;
//                            //卡顿的发生时间为当前时间 - adrLantency
//                            if (_flag == 0) {
//                                _sTime = [CTUtils currentTimeMillis] - _adrLantency * 5;
//                            }
//                            else
//                            {
//                                _sTime = [CTUtils currentTimeMillis] - _adrLantency ;
//                            }
//                            //卡顿
//                            _entity = [[CTCarltonEntity alloc] init];
//                            //卡顿的发生时间为当前时间 - adrLantency
////                            NSLog(@"子线程监控主线程runloop状态 = %lu, runloopId = %ld,_sTime = %lld",self->activity, (long)self->_runloopId,_sTime);
//                            NSString *backTrace = [CTBackTrace ct_backtraceOfMainThread];
//                            [CTLog print:@"✖✖✖✖✖✖✖✖ 发生卡顿了 ✖✖✖✖✖✖✖✖\n【当前堆栈】：%@\n",backTrace];
//                            _entity.stackInfo = backTrace;
//                        }
//                    }
////                    NSLog(@"CloopId = %ld",(long)loopId);
//                }
//            }
//            timeoutCount = 0;
//        }
//    });
}

@end
