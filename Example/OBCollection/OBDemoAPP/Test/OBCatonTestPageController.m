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
    cell.imgV.layer.masksToBounds = YES;
    cell.imgV.layer.cornerRadius = 2;
    cell.imgV.layer.shadowRadius = 2;
    cell.imgV.layer.shadowColor = [UIColor orangeColor].CGColor;
    NSMutableAttributedString *attributedString;
    for (int i = 0; i < 3000; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(arc4random()%375, 16, 50, 50)];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 10;
        view.layer.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:0.5].CGColor;
        [cell.contentView addSubview:view];
    }
    cell.label.attributedText = ({
       attributedString = [[NSMutableAttributedString alloc]
                                                       initWithString:@"Hello,World!♻️🏷➕📣⚠️🔒😀🗳✅🔒🚩👌‼️🔑🏷➕📣⚠️🔒😀🗳✅🔒🚩👌‼️🔑🏷➕📣⚠️🔒😀🗳✅🔒🚩👌‼️🔑🏷➕📣⚠️🔒😀🗳✅🔒🚩👌‼️🔑🏷➕📣⚠️🔒😀🗳✅🔒🚩👌‼️🔑🏷➕📣⚠️🔒😀🗳✅🔒🚩👌‼️🔑"
                                                       attributes:@{
                                                                    NSForegroundColorAttributeName : [UIColor grayColor]
                                                                    }];
        [attributedString appendAttributedString:[[NSAttributedString alloc]
                                                  initWithString:@"Again＠＠🀕🀕🀋🀋ㄉ⑮⑸⑷Πǒ!➕📣⚠️🔒😀🗳✅🔒🚩👌‼️🔑🏷➕📣⚠️🔒😀🗳✅🔒🚩👌‼️🔑🏷＠＠🀕🀕🀋🀋ㄉ⑮⑸⑷Πǒ!＠＠🀕🀕🀋🀋ㄉ⑮⑸⑷Πǒ!＠＠🀕🀕🀋🀋ㄉ⑮⑸⑷Πǒ!＠＠🀕🀕🀋🀋ㄉ⑮⑸⑷Πǒ!＠＠🀕🀕🀋🀋ㄉ⑮⑸⑷Πǒ!"
                                                  attributes:@{
                                                               NSForegroundColorAttributeName : [UIColor blueColor]
                                                               }]];
        [attributedString appendAttributedString:[[NSAttributedString alloc]
                                                  initWithString:@"Again!"
                                                  attributes:@{
                                                               NSForegroundColorAttributeName : [UIColor blueColor]
                                                               }]];
        attributedString;
    });
    return cell;
}

@end
