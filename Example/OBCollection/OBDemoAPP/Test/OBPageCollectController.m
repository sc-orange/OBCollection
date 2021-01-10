//
//  OBPageCollectController.m
//  OBCollection_Example
//
//  Created by orange on 2021/1/10.
//  Copyright © 2021 200887744@qq.com. All rights reserved.
//

#import "OBPageCollectController.h"

@interface OBPageCollectController ()

@property (weak, nonatomic) IBOutlet UILabel *pageTrackInfo;

@end

@implementation OBPageCollectController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)getPageTrackInfo:(UIButton *)sender {
    NSArray *pageArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"ob_page_data"];
    self.pageTrackInfo.text = pageArray.count > 0 ? [pageArray componentsJoinedByString:@"-"] : @"请打开配置开关";
}

@end
