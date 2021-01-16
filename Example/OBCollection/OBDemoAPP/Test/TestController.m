//
//  TestController.m
//  OBModuleDemo
//
//  Created by syh on 2019/2/22.
//  Copyright © 2019 syh. All rights reserved.
//

#import "TestController.h"

static NSString *const kCellIdentifier = @"kCellIdentifier";

@interface TestController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation TestController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    NSDictionary *dic = self.dataArray[indexPath.row];
    cell.textLabel.text = dic[@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataArray[indexPath.row];
    NSString *cls = dic[@"class"];
    UIViewController * vc = [[NSClassFromString(cls) alloc] init];
    vc.title = dic[@"name"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[@{@"name" : @"页面轨迹采集", @"class" : @"OBPageCollectController"},
                       @{@"name" : @"HTTP采集", @"class" : @"OBHttpCollectController"},
                       @{@"name" : @"崩溃采集", @"class" : @"OBCrashCollectController"}
        ];
    }
    return _dataArray;
}

@end
