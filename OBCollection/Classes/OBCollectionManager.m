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

@end

static OBCollectionManager *collectionManager = nil;

@implementation OBCollectionManager

+ (OBCollectionManager *)shareInstance {
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
    }
    return self;
}

- (void)startCollect {
    NSDictionary *setting = [OBConfigSetting readLocalSetting];
    [self makeSettingWith:setting];
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
}

@end
