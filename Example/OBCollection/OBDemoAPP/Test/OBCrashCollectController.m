//
//  OBCrashCollectController.m
//  OBCollection_Example
//
//  Created by orange on 2021/1/16.
//  Copyright © 2021 200887744@qq.com. All rights reserved.
//

#import "OBCrashCollectController.h"

@interface OBCrashCollectController ()
@property (weak, nonatomic) IBOutlet UITextView *crashInfoTextView;

@end

@implementation OBCrashCollectController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)crashAction:(UIButton *)sender {
    NSArray *array = @[@1, @2];
    NSLog(@"%@", array[3]);
}

@end
