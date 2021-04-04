//
//  OBCatonObserver.m
//  KSCrash
//
//  Created by orange on 2021/3/25.
//

#import "OBCatonObserver.h"
#import "OBCatonData.h"
#import "OBCollectionManager.h"

typedef NS_ENUM(NSInteger, OBCatonType) {
    OBCatonTypeShotTime = 0, //5次短时间监测
    OBCatonTypeShotLongTime = 1,  //一次长时间监测
};

#define CatonObserverTime (19.9 * 5)  //卡顿监测临界值

static OBCatonObserver *_manager = nil;

@interface OBCatonObserver () {
    CFRunLoopObserverRef _runLoopObserver;
    dispatch_semaphore_t _semaphore;
    CFRunLoopActivity _activity;
    
    OBCatonType _catonType;  //卡顿监测类型：5次短时间卡顿和一次长时间卡顿
    NSInteger _catonCount;
    NSInteger _catonTime;
    NSInteger _runloopId;  //每次执行到 kCFRunLoopBeforeSources 自动+1，避免卡顿多次统计
    NSInteger _catonLimitTime;  //卡顿阈值
    
    OBCatonData *_entity;
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

- (instancetype)init {
    if (self = [super init]) {
        _catonCount = 0;
        _catonTime = 0;
        _runloopId = 0;
        _catonLimitTime = 19.9;
    }
    return self;
}

- (void)startObserver {
    NSInteger catonTime = [OBCollectionManager sharedInstance].configSetting.catonTime;
    if (catonTime > 0) {
        _catonLimitTime = catonTime;
    }
    if (_catonLimitTime * 5 > CatonObserverTime) {
        _catonLimitTime = _catonLimitTime * 5;
        _catonType = OBCatonTypeShotLongTime;
    }

    if (_runLoopObserver) {
        return;
    }

    if (!_semaphore) {
        _semaphore = dispatch_semaphore_create(1);
    }

    /*
     typedef CF_OPTIONS(CFOptionFlags, CFRunLoopActivity) {
         kCFRunLoopEntry = (1UL << 0),               // 即将进入Loop：1
         kCFRunLoopBeforeTimers = (1UL << 1),        // 即将处理Timer：2
         kCFRunLoopBeforeSources = (1UL << 2),       // 即将处理Source：4
         kCFRunLoopBeforeWaiting = (1UL << 5),       // 即将进入休眠：32
         kCFRunLoopAfterWaiting = (1UL << 6),        // 即将从休眠中唤醒：64
         kCFRunLoopExit = (1UL << 7),                // 即将从Loop中退出：128
         kCFRunLoopAllActivities = 0x0FFFFFFFU       // 监听全部状态改变
     };
     */

    _runLoopObserver = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        @synchronized (self) {
            self->_activity = activity;
        }
        switch (activity) {
            case kCFRunLoopEntry:
                break;
            case kCFRunLoopBeforeTimers:
                break;
            case kCFRunLoopBeforeSources:  //即将处理Source
                @synchronized (self) {
                    self->_runloopId += 1;
                    if (self->_runloopId > 99) {
                        self->_runloopId = 0;
                    }
                }
                break;
            case kCFRunLoopBeforeWaiting:  //即将进入休眠
                if (self->_catonTime != 0) {
                    @synchronized (self) {
                        NSInteger cs = [OBUtils currentSeconds];
                        
                        [OBLog print:@"******卡顿******, 持续时间 = %ld, _catonTime = %ld", cs - self->_catonTime, (long)self->_catonTime];
                        
                        NSArray *pageArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"ob_page_data"];
                        if (pageArray.count > 0) {
                            self->_entity.pageName = pageArray.lastObject;
                        }
                        self->_entity.spendTime = cs - self->_catonTime;
                        [[OBCollectionManager sharedInstance] addCollectionData:self->_entity];
                        self->_catonTime = 0;
                        self->_entity = nil;
                        self->_runloopId = 0;
                    }
                }
                break;
            case kCFRunLoopAfterWaiting:
                break;
            case kCFRunLoopExit:
                break;
            default:
                break;
        }

        dispatch_semaphore_t bSemaphore = self->_semaphore;
        dispatch_semaphore_signal(bSemaphore);
    });

    // 监听执行
    CFRunLoopAddObserver(CFRunLoopGetMain(), _runLoopObserver, kCFRunLoopCommonModes);

    //开启子线程，持续运行监测
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSInteger runLoopId = 0;
        while (1) {
            //设置等待时间：_adrLantency * NSEC_PER_MSEC，如果超过，number不为0
            //number不为0：超时，继续往下执行
            NSInteger number = dispatch_semaphore_wait(self->_semaphore, dispatch_time(DISPATCH_TIME_NOW, self->_catonLimitTime * NSEC_PER_MSEC));;
            if (number != 0) {
                if (!self->_runLoopObserver) {
                    self->_catonCount = 0;
                    return ;
                }
                if (self->_activity == kCFRunLoopBeforeSources || self->_activity == kCFRunLoopAfterWaiting) {
                    // 连续发生5次，则认为是卡顿
                    if (self->_catonType == OBCatonTypeShotTime) {
                        if (++self->_catonCount < 5) {
                            continue;
                        }
                    }
                    if (runLoopId != self->_runloopId) {
                        @synchronized (self) {
                            runLoopId = self->_runloopId;
                            if (self->_catonType == OBCatonTypeShotTime) {
                                self->_catonTime = [OBUtils currentSeconds] - self->_catonLimitTime * 5;
                            } else {
                                self->_catonTime = [OBUtils currentSeconds] - self->_catonLimitTime;
                            }
                            self->_entity = OBCatonData.new;
                            self->_entity.catonActionTime = [OBUtils currentTime];
                        }
                    }
                }
            }
            self->_catonCount = 0;
        }
    });
}

- (void)stopObserver {
    if (!_runLoopObserver) {
        return;
    }
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), _runLoopObserver, kCFRunLoopCommonModes);
    CFRelease(_runLoopObserver);
    _runLoopObserver = NULL;
}

@end
