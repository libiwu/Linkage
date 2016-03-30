//
//  BillDetailViewController.m
//  Linkage
//
//  Created by lihaijian on 16/3/28.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "BillDetailViewController.h"
#import "XLFormDataSource.h"
#import <HMSegmentedControl/HMSegmentedControl.h>
#import "DriverInfoCell.h"

@interface BillDetailViewController()
@property (nonatomic, strong) XLFormDataSource *detailDS;
@property (nonatomic, strong) XLFormDataSource *historyDS;

@end

@implementation BillDetailViewController
-(void)dealloc
{
    self.detailDS = nil;
    self.historyDS = nil;
    self.leftTableView.delegate = nil;
    self.rightTableView.dataSource = nil;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"订单详情";
    [self setupData];
}

-(void)setupData
{
    [self refreshLeftTable];
    [self refreshRightTable];
}

-(void)refreshLeftTable
{
    self.detailDS = [[XLFormDataSource alloc]initWithViewController:self tableView:self.leftTableView];
    [self.detailDS setForm:[self createDetailForm]];
    self.leftTableView.dataSource = self.detailDS;
    self.leftTableView.delegate = self.detailDS;
    if ([self isViewLoaded]){
        [self.leftTableView reloadData];
    }
}

-(void)refreshRightTable
{
    self.historyDS = [[XLFormDataSource alloc]initWithViewController:self tableView:self.rightTableView];
    [self.historyDS setForm:[self createHistoryForm]];
    self.rightTableView.dataSource = self.historyDS;
    self.rightTableView.delegate = self.historyDS;
    if ([self isViewLoaded]){
        [self.rightTableView reloadData];
    }
}

-(XLFormDescriptor *)createDetailForm
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptor];
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText title:@"订单号"];
    row.value = @(111);
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText title:@"接单承运商"];
    row.value = @"B单位";
    [section addFormRow:row];

    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText title:@"柜型1"];
    row.value = @(111);
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText title:@"装货地址"];
    row.value = @"码头西北";
    [section addFormRow:row];

    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText title:@"到厂时间"];
    row.value = @"2016年10月10日";
    [section addFormRow:row];

    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText title:@"送货地址"];
    row.value = @"码头西北";
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText title:@"图片"];
    row.value = @(111);
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText title:@"头程公司"];
    [section addFormRow:row];

    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText title:@"头程船名"];
    [section addFormRow:row];

    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"是否约好"];
    row.value = @YES;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText title:@"是否转关"];
    row.value = @YES;
    [section addFormRow:row];
    
    return form;
}

-(XLFormDescriptor *)createHistoryForm
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    form = [XLFormDescriptor formDescriptor];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"货柜A"];
    [form addFormSection:section];
    
    for (int i = 0; i < 5; i++) {
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:DriverInfoDescriporType];
        [section addFormRow:row];
    }
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"货柜B"];
    [form addFormSection:section];
    
    for (int i = 0; i < 5; i++) {
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:DriverInfoDescriporType];
        [section addFormRow:row];
    }
    
    return form;
}

#pragma mark - 重写
- (HMSegmentedControl *)segmentedControl
{
    HMSegmentedControl *segmentedControl = [super segmentedControl];
    segmentedControl.sectionTitles = @[@"订单进度", @"订单详情"];
    return segmentedControl;
}

@end