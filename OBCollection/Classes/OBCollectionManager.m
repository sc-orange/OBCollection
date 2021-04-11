//
//  OBCollectionManager.m
//  ForORTest
//
//  Created by orange on 2020/11/23.
//

#import "OBCollectionManager.h"
#import "OBConfigSetting.h"
#import "NSDictionary+OBSafeDictionary.h"

@interface OBCollectionManager()

@property (nonatomic, strong) dispatch_queue_t addQueue;

@end

static OBCollectionManager *collectionManager = nil;

@implementation OBCollectionManager

+ (OBCollectionManager *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        collectionManager = [[OBCollectionManager alloc] init];
    });
    return collectionManager;
}

- (id)init {
    self = [super init];
    if(self) {
        self.configSetting = [[OBConfigSetting alloc] init];
        //采集类
        self.crashCollect = [OBCrashCollect sharedInstance];
        self.pageTrackerCollect = [[OBPageTrackerCollect alloc] init];
        self.httpCollect = [[OBNSURLSessionCollect alloc] init];
        self.catonObserver = [[OBCatonObserver alloc] init];
        self.webViewCollect = [[OBWebViewCollect alloc] init];
        //采集保存数据类
        self.crashData = [[OBCrashData alloc] init];
        self.httpDataArray = [NSMutableArray array];
        self.httpErrorDataArray = [NSMutableArray array];
        self.catonDataArray = [NSMutableArray array];
    }
    return self;
}

#pragma mark - 配置相关
- (void)startCollect {
    NSDictionary *setting = [self.configSetting readLocalSetting];
    [self makeSettingWith:setting];
    
    self.addQueue = dispatch_queue_create("add_queue", DISPATCH_QUEUE_SERIAL);
    //读取SDK崩溃信息
    __weak typeof(self)weakSelf = self;
    [[OBCrashCollect sharedInstance] readCreshData:^(OBCrashData * _Nonnull crashData) {
        weakSelf.crashData = crashData;
    }];
}

- (void)makeSettingWith:(NSDictionary *)setting {
    [self.configSetting setConfigSetting:setting];
    self.pageTrackerCollect.isEnabled = self.configSetting.pageTrackSwitch;
    
    if (self.configSetting.crashSwitch) {
        [self.crashCollect startCollect];
    }else {
        [self.crashCollect stopCollect];
    }
    
    if (self.configSetting.httpSwitch) {
        [self.httpCollect startCollect];
    }else {
        [self.httpCollect stopCollect];
    }
    
    if (self.configSetting.catonSwitch) {
        [self.catonObserver startObserver];
    }else {
        [self.catonObserver stopObserver];
    }
    
    if (self.configSetting.webViewSwitch) {
        [self.webViewCollect startWebViewCollect];
    }else {
        [self.webViewCollect stopWebViewCollect];
    }
}

- (void)stopCollect {
    self.pageTrackerCollect.isEnabled = NO;
    [self.crashCollect stopCollect];
    [self.httpCollect stopCollect];
    [self.catonObserver stopObserver];
    
    if(self.addQueue) {
        self.addQueue = nil;
    }
}

+ (void)openLog:(BOOL)open {
    [OBLog canOpenLog:open];
    open?[OBLog print:@"开启打印"]:[OBLog print:@"关闭打印"];
}

#pragma mark - 采集相关
- (void)addCollectionData:(OBData *)data {
    __weak typeof(self)weakSelf = self;
    if(self.addQueue && data) {
        dispatch_async(self.addQueue, ^{
            NSInteger dataCount = 0; //当前数据数量
            NSInteger maxCount = 50; //最大存储数量
            
            if([data isKindOfClass:[OBHttpData class]]) {
                OBHttpData *httpData = (OBHttpData *)data;
                NSInteger statusCode = httpData.responseStatusCode.integerValue;
                BOOL isError = (statusCode >= 400 ||statusCode < 200);
                
                
                if (isError) {
                    if (weakSelf.httpErrorDataArray) {
                        [weakSelf.httpErrorDataArray addObject:httpData];
                        dataCount = weakSelf.httpErrorDataArray.count;
                    }
                }
                
                if(weakSelf.httpDataArray) {
                    [weakSelf.httpDataArray addObject:httpData];
                    dataCount = weakSelf.httpDataArray.count;
                }
                [OBLog print:@"http请求:\n%@",[data description]];
            }
            else if ([data isKindOfClass:[OBCatonData class]]) {
                if (weakSelf.catonDataArray) {
                    [weakSelf.catonDataArray addObject:(OBCatonData *)data];
                    dataCount = weakSelf.catonDataArray.count;
                }
                [OBLog print:@"卡顿数据:\n%@",[data description]];
            }
            
            if(dataCount >= maxCount) {
                [OBLog print:@"达到最大数量处理数据....."];
            }
        });
    }
}

@end
