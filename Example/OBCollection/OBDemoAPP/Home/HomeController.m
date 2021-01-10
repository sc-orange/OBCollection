//
//  HomeController.m
//  OBModuleDemo
//
//  Created by syh on 2019/2/22.
//  Copyright © 2019 syh. All rights reserved.
//

#import "HomeController.h"
#import <OBCollection/OBCollection.h>

@interface HomeController ()
@property (weak, nonatomic) IBOutlet UISwitch *pageCollectSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *crachCollectSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *httpCollectSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *webViewCollectSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *catonCollectSwitch;


@end

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *dic = [[OBCollectionManager sharedInstance].configSetting readLocalSetting];
    self.pageCollectSwitch.on = [dic boolForKey:OBPageTrackSetting];
    self.crachCollectSwitch.on = [dic boolForKey:OBCrashSetting];
    self.httpCollectSwitch.on = [dic boolForKey:OBHttpSetting];
    self.webViewCollectSwitch.on = [dic boolForKey:OBWebViewSetting];
    self.catonCollectSwitch.on = [dic boolForKey:OBCatonSetting];
}

- (IBAction)collectClick:(UISwitch *)sender {
    NSDictionary *setting = [self checkAllSwitch];
    [[OBCollectionManager sharedInstance].configSetting refreshLocalSetting:setting];
}

- (NSDictionary *)checkAllSwitch {
    BOOL isPageCollect = self.pageCollectSwitch.isOn;
    BOOL isCrashCollect = self.crachCollectSwitch.isOn;
    BOOL isHttpCollect = self.httpCollectSwitch.isOn;
    BOOL isWebViewCollect = self.webViewCollectSwitch.isOn;
    BOOL isCatonCollect = self.catonCollectSwitch.isOn;
    return @{OBPageTrackSetting : @(isPageCollect), OBCrashSetting : @(isCrashCollect), OBHttpSetting : @(isHttpCollect), OBWebViewSetting : @(isWebViewCollect), OBCatonSetting : @(isCatonCollect)};
}

@end
