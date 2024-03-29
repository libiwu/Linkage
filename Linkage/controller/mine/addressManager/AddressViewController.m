//
//  AddressViewController.m
//  Linkage
//
//  Created by lihaijian on 16/3/21.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "AddressViewController.h"
#import "AddressUtil.h"
#import "LoginUser.h"
#import "AddAddressViewController.h"
#import "ModelOperation.h"
#import "FormDescriptorCell.h"
#import "MJRefresh.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface AddressViewController()
@property (nonatomic, assign) AddressType addressType;
@end

@implementation AddressViewController

-(instancetype)initWithControllerType:(ControllerType)controllerType addressType:(AddressType)addType
{
    self = [super initWithControllerType:controllerType];
    if (self) {
        self.addressType = addType;
    }
    return self;
}

-(Class)modelUtilClass
{
    return [AddressUtil class];
}

-(Class)viewControllerClass
{
    return [AddAddressViewController class];
}

-(void)setupNavigationItem
{
    UIBarButtonItem *addBtn = self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAction:)];
    self.navigationItem.rightBarButtonItem = addBtn;
}

- (void)setupData:(void(^)(NSArray *models))completion
{
    WeakSelf
    NSPredicate *predicate;
    if (self.addressType != 0) {
        predicate = [NSPredicate predicateWithFormat:@"userId = %@ AND title = %@", [LoginUser shareInstance].cid, @(self.addressType)];
    }else{
        predicate = [NSPredicate predicateWithFormat:@"userId = %@", [LoginUser shareInstance].cid];
    }
    [self.modelUtilClass queryModelsFromDataBase:predicate completion:^(NSArray *models) {
        [weakSelf initializeForm:models];
        if (completion) {
            completion(models);
        }
    }];
}

-(void)didSelectModel:(XLFormRowDescriptor *)chosenRow
{
    id<MTLJSONSerializing,XLFormTitleOptionObject> chosenValue = chosenRow.value;
    self.rowDescriptor.value = [chosenValue formDisplayText];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
