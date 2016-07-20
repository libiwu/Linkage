//
//  ModelBaseViewController.m
//  Linkage
//
//  Created by Mac mini on 16/4/28.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "ModelBaseViewController.h"
#import "ModelOperation.h"
#import "FormDescriptorCell.h"
#import <MJRefresh/MJRefresh.h>
#import <SVProgressHUD/SVProgressHUD.h>

#define RowUI [row.cellConfig setObject:@(NSTextAlignmentLeft) forKey:@"textLabel.textAlignment"];\
row.cellStyle = UITableViewCellStyleValue1;

@interface ModelBaseViewController()
@property (nonatomic, assign) ControllerType controllerType;
@end

@implementation ModelBaseViewController
@synthesize rowDescriptor = _rowDescriptor;

- (instancetype)initWithControllerType:(ControllerType)controllerType
{
    self = [super init];
    if (self) {
        self.controllerType = controllerType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

-(void)setupUI
{
    WeakSelf
    self.tableView.sectionHeaderHeight = 20;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 18)];
    [self.tableView setEditing:NO];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.modelUtilClass queryModelsFromServer:^(NSArray *models) {
            if(models.count > 0){
                for (id model in models) {
                    [self.modelUtilClass syncToDataBase:model completion:nil];
                }
            }else{
                [self.modelUtilClass truncateAll];
            }
            StrongSelf
            [[NSManagedObjectContext MR_defaultContext] MR_saveWithOptions:MRSaveParentContexts | MRSaveSynchronously completion:^(BOOL contextDidSave, NSError * error) {
                [strongSelf setupData];
            }];
            if([weakSelf.tableView.mj_header isRefreshing]){
                [weakSelf.tableView.mj_header endRefreshing];
            }
        }];
    }];
    
    [self setupNavigationItem];
}

-(void)setupNavigationItem
{
    if (self.controllerType == ControllerTypeManager) {
        UIBarButtonItem *editBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editAction:)];
        UIBarButtonItem *addBtn = self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAction:)];
        self.navigationItem.rightBarButtonItems = @[editBtn, addBtn];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (![self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header beginRefreshing];
    }
}

- (void)setupData
{
    WeakSelf
    [self.modelUtilClass queryModelsFromDataBase:^(NSArray *models) {
        [weakSelf initializeForm:models];
    }];
}

- (void)initializeForm:(NSArray *)models
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptorWithTitle:@""];
    section = [XLFormSectionDescriptor formSectionWithTitle:@""];
    [form addFormSection:section];
    
    for (id<MTLJSONSerializing,XLFormTitleOptionObject> model in models) {
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeButton title:[model formTitleText]];
        RowUI
        row.value = model;
        if (self.controllerType == ControllerTypeQuery) {
            //选择行后处理事件
            row.action.formSelector = @selector(didSelectModel:);
        }else{
            //进入详情页面
            row.action.viewControllerClass = self.viewControllerClass;
        }
        [section addFormRow:row];
    }
    self.form = form;
}

#pragma mark - action
-(void)editAction:(UIBarButtonItem *)sender
{
    if(!self.tableView.isEditing){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(editAction:)];
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editAction:)];
    }
    [self.tableView setEditing:!self.tableView.isEditing];
}

-(void)addAction:(UIBarButtonItem *)sender
{
    id viewController = [[self.viewControllerClass alloc]init];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - UITableViewDataSource
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeakSelf
    if (editingStyle == UITableViewCellEditingStyleDelete){
        XLFormRowDescriptor * row = [self.form formRowAtIndex:indexPath];
        [row.sectionDescriptor removeFormRowAtIndex:indexPath.row];
        [SVProgressHUD show];
        [self.modelUtilClass deleteFromServer:row.value success:^(id responseData) {
            StrongSelf
            [self.modelUtilClass deleteFromDataBase:row.value completion:^{
                [SVProgressHUD dismiss];
                [[NSManagedObjectContext MR_defaultContext] MR_saveWithOptions:MRSaveParentContexts | MRSaveSynchronously completion:nil];
                [strongSelf setupData];
            }];
        } failure:^(NSError *error) {
            
        }];
    }
}

@end