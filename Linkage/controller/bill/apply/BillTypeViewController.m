//
//  BillTypeViewController.m
//  Linkage
//
//  Created by lihaijian on 16/3/20.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "BillTypeViewController.h"
#import "BillApplyViewController.h"

#define kBillTypeArray @[@"出口订单",@"进口订单",@"自备柜配送"]
@interface BillTypeViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation BillTypeViewController
@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单类型";
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.bottom.equalTo(self.view.bottom);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"typeCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"typeCell"];
    }
    cell.textLabel.text = [kBillTypeArray objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"tab_icon_selection_highlight"];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BillApplyViewController *billApplyVC;
    if (indexPath.row == 0) {
        billApplyVC = [[BillExportApplyViewController alloc]init];
    }else if(indexPath.row == 1){
        billApplyVC = [[BillImportApplyViewController alloc]init];
    }else{
        billApplyVC = [[BillCustomApplyViewController alloc]init];
    }
    [self.navigationController pushViewController:billApplyVC animated:YES];
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

@end
