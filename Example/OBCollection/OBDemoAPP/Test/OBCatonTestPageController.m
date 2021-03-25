//
//  OBCatonTestPageController.m
//  OBCollection_Example
//
//  Created by orange on 2021/3/24.
//  Copyright © 2021 200887744@qq.com. All rights reserved.
//

#import "OBCatonTestPageController.h"
#import "OBCatonTestCell.h"

@interface OBCatonTestPageController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation OBCatonTestPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 60;
    [self.tableView registerNib:[UINib nibWithNibName:@"OBCatonTestCell" bundle:nil] forCellReuseIdentifier:@"OBCatonTestCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OBCatonTestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OBCatonTestCell" forIndexPath:indexPath];
    return cell;
}

@end
