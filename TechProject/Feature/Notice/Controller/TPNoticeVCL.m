//
//  TPNoticeVCL.m
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/8.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import "TPNoticeVCL.h"
#import "TPCommonViewHelper.h"
#import "TPNoticeCategoryItem.h"
#import "TPNoticeModel.h"
#import "TPCommonDefine.h"
#import "TPNoticeListVCL.h"
#import "TPNoticeCategoryCell.h"
#import <MJRefresh.h>
@interface TPNoticeVCL ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) TPNoticeModel *model;
@end

@implementation TPNoticeVCL

- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
         self.model = [TPNoticeModel new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNaviBar];
    __weak typeof(self) instance = self;
    [self.collectionView addRefreshHeaderWithHandle:^{
        [instance loadData];
    }];

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(TPScreenWidth/4, TPScreenWidth/4);
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.frame = CGRectMake(0, TPStatusBarAndNavigationBarHeight, TPScreenWidth, TPScreenHeight - TPStatusBarAndNavigationBarHeight - TPTabbarSafeBottomMargin);
    [self loadData];
    // Do any additional setup after loading the view.
}

- (void)addNaviBar{
    UIView *naviBar = [TPCommonViewHelper createNavigationBar:@"公告" enableBackButton:NO];
    [self.view addSubview:naviBar];
}

- (void)loadData{
    if (!self.model.items || self.model.items.count < 1) {
        [self showLoading];
    }
    __weak typeof(self) instance = self;
    [self.model loadItems:nil completion:^(NSDictionary *success) {
        [instance hideLoading];
        [instance.collectionView.refreshHeader endRefreshing];
        [instance.collectionView reloadData];
    } failure:^(NSError *error) {
        [instance hideLoading];
        [instance.collectionView.refreshHeader endRefreshing];
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.model.items.count;;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TPNoticeCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TPNoticeCategoryCell" forIndexPath:indexPath];
    TPNoticeCategoryItem *item = self.model.items[indexPath.row];
    cell.text  = item.name;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TPNoticeListVCL *listVCL = (TPNoticeListVCL *)[main instantiateViewControllerWithIdentifier:@"TPNoticeListVCL"];
    TPNoticeCategoryItem *item = self.model.items[indexPath.row];
    listVCL.categoryId = item.cId;
    [self.navigationController pushViewController:listVCL animated:YES];
}
@end

