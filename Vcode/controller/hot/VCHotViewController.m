//
//  VCHotViewController.m
//  Linkage
//
//  Created by Mac mini on 2017/1/3.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCHotViewController.h"
#import "ZJScrollPageView.h"
#import "VCHotChildViewController.h"
#import "VCHomeViewController.h"
#import "VCCategoryUtil.h"
#import "VCSearchView.h"

@interface VCHotViewController ()<ZJScrollPageViewDelegate>
@property(strong, nonatomic)NSArray<NSString *> *titles;
@property (nonatomic, readonly) VCSearchView *searchView;
@end

@implementation VCHotViewController
@synthesize searchView = _searchView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

-(void)setupUI
{
    UIButton *brandBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 44)];
    [brandBtn setImage:[UIImage imageNamed:@"google"] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:brandBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH - 80, 44)];
    UIBarButtonItem *centerItem = [[UIBarButtonItem alloc]initWithCustomView:searchBar];
    self.navigationItem.rightBarButtonItem = centerItem;
    //顶部栏
    [self setupTopScrollView];
}

-(void)setupTopScrollView
{
    //必要的设置, 如果没有设置可能导致内容显示不正常
    self.automaticallyAdjustsScrollViewInsets = NO;
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    style.scaleTitle = YES;
    style.showLine = NO;
    style.gradualChangeTitleColor = YES;
    // 设置附加按钮的背景图片
    self.titles = [VCCategoryUtil queryAllCategoryTitles];
    ZJScrollPageView *scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64.0) segmentStyle:style titles:self.titles parentViewController:self delegate:self];
    [self.view addSubview:scrollPageView];
}


#pragma ZJScrollPageViewDelegate 代理方法
- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    UIViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    if (!childVc) {
        if (index == 0) {
            childVc = [[VCHomeViewController alloc]init];
        }else{
            childVc = [[VCHotChildViewController alloc] init];
            childVc.title = self.titles[index];
        }
    }
    return childVc;
}


- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllWillAppear:(UIViewController *)childViewController forIndex:(NSInteger)index {
    //NSLog(@"%ld ---将要出现",index);
}

- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllDidAppear:(UIViewController *)childViewController forIndex:(NSInteger)index {
    //NSLog(@"%ld ---已经出现",index);
}

- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllWillDisappear:(UIViewController *)childViewController forIndex:(NSInteger)index {
    //NSLog(@"%ld ---将要消失",index);
}


- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllDidDisappear:(UIViewController *)childViewController forIndex:(NSInteger)index {
    //NSLog(@"%ld ---已经消失",index);
}

-(BOOL)shouldAutomaticallyForwardAppearanceMethods
{
    return NO;
}

#pragma mark - getter setter
-(VCSearchView *)searchView
{
    if (!_searchView) {
        _searchView = [[VCSearchView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 49)];
    }
    return _searchView;
}

@end
