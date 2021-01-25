//
//  OBCrashCollectController.m
//  OBCollection_Example
//
//  Created by orange on 2021/1/16.
//  Copyright © 2021 200887744@qq.com. All rights reserved.
//

#import "OBCrashCollectController.h"
#import <OBCollection/OBCollection.h>

@interface OBCrashCollectController ()
@property (weak, nonatomic) IBOutlet UITextView *crashInfoTextView;

@end

@implementation OBCrashCollectController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)crashAction:(UIButton *)sender {
    NSArray *array = @[@1, @2];
    NSLog(@"%@", array[3]);
}
- (IBAction)crashInfo:(UIButton *)sender {
    OBCrashData *data = [OBCollectionManager sharedInstance].crashData;
    self.crashInfoTextView.text = data ? data.crashInfo : @"暂无崩溃信息";
}
- (IBAction)crashExtInfo:(UIButton *)sender {
    OBCrashData *data = [OBCollectionManager sharedInstance].crashData;
    self.crashInfoTextView.text = data ? [data description] : @"暂无崩溃信息";
}

@end
