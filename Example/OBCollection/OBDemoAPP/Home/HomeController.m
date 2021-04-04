//
//  HomeController.m
//  OBModuleDemo
//
//  Created by syh on 2019/2/22.
//  Copyright © 2019 syh. All rights reserved.
//

#import "HomeController.h"
#import <OBCollection/OBCollection.h>

@interface HomeController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *pageCollectSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *crachCollectSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *httpCollectSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *webViewCollectSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *catonCollectSwitch;
@property (weak, nonatomic) IBOutlet UITextField *catonTimeTextField;
@property (copy, nonatomic) NSString *catonTime;

@end

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.catonTimeTextField.delegate = self;
    
    NSDictionary *dic = [[OBCollectionManager sharedInstance].configSetting readLocalSetting];
    self.pageCollectSwitch.on = [dic boolForKey:OBPageTrackSetting];
    self.crachCollectSwitch.on = [dic boolForKey:OBCrashSetting];
    self.httpCollectSwitch.on = [dic boolForKey:OBHttpSetting];
    self.webViewCollectSwitch.on = [dic boolForKey:OBWebViewSetting];
    self.catonCollectSwitch.on = [dic boolForKey:OBCatonSetting];
    NSString *catonTime = [dic stringForKey:OBCatonTime];
    self.catonTime = catonTime.length > 0 ? catonTime : @"0";
    self.catonTimeTextField.text = self.catonTime;
}

- (IBAction)collectClick:(UISwitch *)sender {
    [self refreshSetting];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    self.catonTime = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self refreshSetting];
    return YES;
}

- (void)refreshSetting {
    NSDictionary *setting = [self checkAllSetting];
    [[OBCollectionManager sharedInstance].configSetting refreshLocalSetting:setting];
}

- (NSDictionary *)checkAllSetting {
    BOOL isPageCollect = self.pageCollectSwitch.isOn;
    BOOL isCrashCollect = self.crachCollectSwitch.isOn;
    BOOL isHttpCollect = self.httpCollectSwitch.isOn;
    BOOL isWebViewCollect = self.webViewCollectSwitch.isOn;
    BOOL isCatonCollect = self.catonCollectSwitch.isOn;
    NSDictionary *settingDic = @{OBPageTrackSetting : @(isPageCollect), OBCrashSetting : @(isCrashCollect), OBHttpSetting : @(isHttpCollect), OBWebViewSetting : @(isWebViewCollect), OBCatonSetting : @(isCatonCollect), OBCatonTime : self.catonTime};
    return settingDic;
}

@end
