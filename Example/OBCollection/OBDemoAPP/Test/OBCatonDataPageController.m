//
//  OBCatonDataPageController.m
//  OBCollection_Example
//
//  Created by orange on 2021/4/4.
//  Copyright © 2021 200887744@qq.com. All rights reserved.
//

#import "OBCatonDataPageController.h"
#import <OBCollection/OBCollection.h>

@interface OBCatonDataPageController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation OBCatonDataPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return OBCollectionManager.sharedInstance.catonDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:@"cell"];
    OBCatonData *data = OBCollectionManager.sharedInstance.catonDataArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = [NSString stringWithFormat:@"卡顿页面：%@\n卡顿发生时间：%@\n卡顿持续时间：%ld ms", data.pageName,data.catonActionTime, data.spendTime];
    return cell;
}

@end
