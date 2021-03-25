//
//  OBConfigSetting.m
//  ForORTest
//
//  Created by orange on 2020/11/23.
//

#import "OBConfigSetting.h"

@implementation OBConfigSetting

- (instancetype)init {
    if (self = [super init]) {
        _pageTrackSwitch = NO;
        _crashSwitch = NO;
        _httpSwitch = NO;
        _webViewSwitch = NO;
        _catonSwitch = NO;
        _catonTime = 0;
    }
    return self;
}

- (void)setConfigSetting:(NSDictionary *)setting {
    self.pageTrackSwitch = [setting boolForKey:OBPageTrackSetting];
    self.crashSwitch = [setting boolForKey:OBCrashSetting];
    self.httpSwitch = [setting boolForKey:OBHttpSetting];
    self.webViewSwitch = [setting boolForKey:OBWebViewSetting];
    self.catonSwitch = [setting boolForKey:OBCatonSetting];
    self.catonTime = [setting integerForKey:OBCatonTime];
}

- (NSDictionary *)readLocalSetting {
    id setting = [[NSUserDefaults standardUserDefaults] objectForKey:@"ob_local_setting"];
    if ([setting isKindOfClass:NSDictionary.class]) {
        return setting;
    }
    return nil;
}

- (void)saveLocalSetting:(NSDictionary *)setting {
    [[NSUserDefaults standardUserDefaults] setObject:setting forKey:@"ob_local_setting"];
}

- (void)refreshLocalSetting:(NSDictionary *)setting {
    NSDictionary *localSampling = [self readLocalSetting];
    if(!localSampling || ![setting isEqualToDictionary:localSampling]) {
        [self saveLocalSetting:setting];
    }
}

@end
