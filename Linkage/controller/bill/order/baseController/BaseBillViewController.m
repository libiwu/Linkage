//
//  BaseBillViewController.m
//  Linkage
//
//  Created by Mac mini on 16/3/4.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "BaseBillViewController.h"
#import "UIColor+BFPaperColors.h"
#import "OrderUtil.h"
#import "MJRefresh.h"

@interface BaseBillViewController()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation BaseBillViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

-(void)setupUI
{
    [self.view addSubview:self.segmentedControl];
    [self.segmentedControl makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.top.equalTo(self.view.top);
        make.height.equalTo(44);
    }];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentedControl.bottom);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.bottom.equalTo(self.view.bottom);
    }];
    
    UIView *contentView = [UIView new];
    {
        [self.scrollView addSubview:contentView];
        [contentView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.scrollView);
            make.height.equalTo(self.scrollView.height);
        }];
    }
    
    [contentView addSubview:self.leftTableView];
    [self.leftTableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.width.equalTo(IPHONE_WIDTH);
        make.height.equalTo(contentView.height);
    }];
    
    [contentView addSubview:self.rightTableView];
    [self.rightTableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftTableView.right);
        make.top.equalTo(@0);
        make.width.equalTo(IPHONE_WIDTH);
        make.height.equalTo(contentView.height);
    }];
    
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightTableView.right);
    }];
}

- (void)segmentedControlChangeIndex:(NSInteger)index
{
    
}

#pragma mark - scrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    [self.segmentedControl setSelectedSegmentIndex:page animated:YES];
    [self segmentedControlChangeIndex:page];
}

#pragma mark - 属性
- (HMSegmentedControl *)segmentedControl
{
    WeakSelf
    if (!_segmentedControl) {
        _segmentedControl = [HMSegmentedControl new];
        _segmentedControl.sectionTitles = @[@"未完成", @"已完成"];
        _segmentedControl.selectedSegmentIndex = 0;
        _segmentedControl.backgroundColor = [UIColor whiteColor];
        _segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor grayColor], NSFontAttributeName : [UIFont systemFontOfSize:16.0f]};
        _segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : ButtonColor};
        _segmentedControl.selectionIndicatorColor = ButtonColor;
        _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentedControl.selectionIndicatorHeight = 2.f;
        //_segmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, 0, -2, 0);
        [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
            if (index == 0) {
                [weakSelf.scrollView scrollRectToVisible:weakSelf.leftTableView.frame animated:YES];
            }else{
                [weakSelf.scrollView scrollRectToVisible:weakSelf.rightTableView.frame animated:YES];
            }
            [weakSelf segmentedControlChangeIndex:index];
        }];
    }
    return _segmentedControl;
}

-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)performFormSelector:(SEL)selector withObject:(id)sender
{
    UIResponder * responder = [self targetForAction:selector withSender:sender];;
    if (responder) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Warc-performSelector-leaks"
        [responder performSelector:selector withObject:sender];
#pragma GCC diagnostic pop
    }
}

@end
