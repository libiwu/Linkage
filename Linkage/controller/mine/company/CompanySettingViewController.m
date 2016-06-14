//
//  CompanySettingViewController.m
//  Linkage
//
//  Created by lihaijian on 16/3/20.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "CompanySettingViewController.h"
#import "XLFormViewController+ImagePicker.h"
#import "Company.h"
#import "ImageCacheManager.h"
#import "SOImage.h"
#import "SOImageFormCell.h"
#import "AvatarFormCell.h"
#import "CompanyUtil.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <Mantle/Mantle.h>

@interface CompanySettingViewController ()

@end

@implementation CompanySettingViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initializeForm];
    }
    return self;
}

- (void)initializeForm
{
    XLFormDescriptor *form = [self createForm:nil];
    self.form = form;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.sectionHeaderHeight = 20;
    self.tableView.sectionFooterHeight = 0;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveAction:)];
    [self setupData];
}

-(void)setupData
{
    Company *company = [Company shareInstance];
    if(company){
        XLFormDescriptor *form = [self createForm:company];
        [self setForm:form];
    }
}

-(XLFormDescriptor *)createForm:(Company *)company
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptorWithTitle:@"企业设置"];
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"logo" rowType:CompanyLogoDescriporType title:@"企业Logo"];
    if (company) {
        row.value = company.logo;
    }
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"company_name" rowType:XLFormRowDescriptorTypeText title:@"企业名称"];
    if (company) {
        row.value = company.companyName;
    }
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"description" rowType:XLFormRowDescriptorTypeTextView title:@"企业简介"];
    if (company) {
        row.value = company.introduction;
    }
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"contact_name" rowType:XLFormRowDescriptorTypeText title:@"企业联系人"];
    if (company) {
        row.value = company.contactName;
    }
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"contact_address" rowType:XLFormRowDescriptorTypeText title:@"企业地址"];
    if (company) {
        row.value = company.address;
    }
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"email" rowType:XLFormRowDescriptorTypeEmail title:@"企业邮箱"];
    if (company) {
        row.value = company.email;
    }
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"fax" rowType:XLFormRowDescriptorTypeText title:@"传真"];
    if (company) {
        row.value = company.fax;
    }
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"url" rowType:XLFormRowDescriptorTypeURL title:@"企业网址"];
    if (company) {
        row.value = company.url;
    }
    [section addFormRow:row];
    
    //图片
    section = [SpecialFormSectionDescriptor formSection];
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeButton title:@"企业图片"];
    [row.cellConfig setObject:@(NSTextAlignmentNatural) forKey:@"textLabel.textAlignment"];
    row.action.formSelector = NSSelectorFromString(@"addPhotoButtonTapped:");
    section.multivaluedTag = @"photos";
    [section addFormRow:row];
    if (company) {
        for (NSString *imageKey in company.companyImages) {
            //添加到当前列的value里面
            SOImage *model = [[SOImage alloc]init];
            model.imageName = imageKey;
            model.createDate = [NSDate date];
            
            row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:SOImageRowDescriporType];
            row.value = model;
            [section addFormRow:row];
        }
    }
    
    //客户电话
    section = [XLFormSectionDescriptor formSectionWithTitle:nil sectionOptions:XLFormSectionOptionCanInsert|XLFormSectionOptionCanDelete sectionInsertMode:XLFormSectionInsertModeButton];
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypePhone title:@"客户电话"];
    [section.multivaluedAddButton.cellConfig setObject:@"添加客户电话" forKey:@"textLabel.text"];
    section.multivaluedRowTemplate = row;
    section.multivaluedTag = @"customerPhones";
    if (company) {
        for (NSString *photoNum in company.customerPhones) {
            row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypePhone title:@"客户电话"];
            row.value = photoNum;
            [section addFormRow:row];
        }
    }else{
        [section addFormRow:row];
    }
    
    return form;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 按钮事件
-(void)saveAction:(id)sender
{
    NSMutableDictionary *formValues = [[self formValues] mutableCopy];
    //保存图片到硬盘
    NSMutableArray *companyImages = [NSMutableArray array];
    NSArray *formPhotos = formValues[@"photos"];
    if (formPhotos) {
        for (SOImage *imageModel in formPhotos) {
            [[ImageCacheManager sharedManger] diskImageExistsWithKey:imageModel.imageName completion:^(BOOL isInCache) {
                if (!isInCache) {
                    [[ImageCacheManager sharedManger] storeImage:imageModel.image forKey:imageModel.imageName];
                }
            }];
            [companyImages addObject:imageModel.imageName];
        }
    }
    formValues[@"companyImages"] = companyImages;
    //保存到UserDefault
    Company *company = [MTLJSONAdapter modelOfClass:[Company class] fromJSONDictionary:formValues error:nil];
    [CompanyUtil syncToServer:company success:^(id responseData) {
        BOOL saveSuccess = [company save];
        if (saveSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showSuccessWithStatus:@"保存失败"];
    }];
}

#pragma mark - 重写tableviewDataSource方法
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self imageWithTableView:tableView editingStyleForRowAtIndexPath:indexPath];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self imageWithTableView:tableView editingStyleForRowAtIndexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self imageWithTableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
}

@end
