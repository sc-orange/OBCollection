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
        self.pageTrackerCollect = [[OBPageTrackerCollect alloc] init];
        self.httpCollect = [[OBNSURLSessionCollect alloc] init];
        
        self.httpDataArray = [NSMutableArray array];
        self.httpErrorDataArray = [NSMutableArray array];
        
    }
    return self;
}

#pragma mark - 配置相关
- (void)startCollect {
    NSDictionary *setting = [self.configSetting readLocalSetting];
    [self makeSettingWith:setting];
    
    self.addQueue = dispatch_queue_create("add_queue", DISPATCH_QUEUE_SERIAL);
    
    [[OBCrashCollect sharedInstance] readCresh];
}

- (void)makeSettingWith:(NSDictionary *)setting {
    [self.configSetting setConfigSetting:setting];
    self.pageTrackerCollect.isEnabled = self.configSetting.pageTrackSwitch;
    if (self.configSetting.httpSwitch) {
        [self.httpCollect startCollect];
    }
    
}

- (void)stopCollect {
    self.pageTrackerCollect.isEnabled = NO;
    [self.httpCollect stopCollect];
    
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
    __weak typeof(self)weakself = self;
    if(self.addQueue && data) {
        dispatch_async(self.addQueue, ^{
            NSInteger dataCount = 0; //当前数据数量
            NSInteger maxCount = 50; //最大存储数量
            
            if([data isKindOfClass:[OBHttpData class]]) {
                OBHttpData *httpData = (OBHttpData *)data;
                NSInteger statusCode = httpData.responseStatusCode.integerValue;
                BOOL isError = (statusCode >= 400 ||statusCode < 200);
                
                
                if (isError) {
                    if (weakself.httpErrorDataArray) {
                        [weakself.httpErrorDataArray addObject:httpData];
                        dataCount = weakself.httpErrorDataArray.count;
                    }
                }
                
                if(weakself.httpDataArray) {
                    [weakself.httpDataArray addObject:httpData];
                    dataCount = weakself.httpDataArray.count;
                }
                [OBLog print:@"http请求:\n%@",[data description]];
            }
            
            if(dataCount >= maxCount) {
                [OBLog print:@"达到最大数量处理数据....."];
            }
        });
    }
}

@end
