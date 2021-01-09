//
//  TestController.m
//  OBModuleDemo
//
//  Created by syh on 2019/2/22.
//  Copyright © 2019 syh. All rights reserved.
//

#import "TestController.h"

@interface TestController ()

@property (weak, nonatomic) IBOutlet UILabel *pageTrackInfo;

@end

@implementation TestController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)getPageTrackInfo:(UIButton *)sender {
    NSArray *pageArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"ob_page_data"];
    self.pageTrackInfo.text = pageArray.count > 0 ? [pageArray componentsJoinedByString:@"-"] : @"请打开配置开关";
}

@end
