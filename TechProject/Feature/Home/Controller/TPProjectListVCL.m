//
//  TPProjectListVCL.m
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/10.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import "TPProjectListVCL.h"
#import "TPProjectListModel.h"
#import "TPProjectListCell.h"
#import "TPCommonDefine.h"
#import "TPCollectionFlowLayout.h"
#import "TPProjectDetailVCL.h"
#import "TPBarItem.h"
#import "TPProjectDataManager.h"
@interface TPProjectListVCL ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) TPProjectListModel *model;
@end

@implementation TPProjectListVCL

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    self.model = [TPProjectListModel new];
    [self addNaviBar];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 14;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(TPScreenWidth - 32, 84);
    layout.sectionInset = UIEdgeInsetsMake(14, 0, 14, 0);
    
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.frame = CGRectMake(0, TPStatusBarAndNavigationBarHeight, TPScreenWidth, self.view.height - TPStatusBarAndNavigationBarHeight);
    self.collectionView.hidden = YES;
    [self loadItems];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void)loadItems{
    if (!self.model.items || self.model.items.count < 1) {
        [self showLoading];
        [self hideNoDataView];
    }
    __weak typeof(self) instance = self;
    NSString *rId = self.region.regionId ?: @"";
    [self.model loadItems:@{@"rId":rId} completion:^(NSDictionary *suc) {
        [instance hideLoading];
        instance.collectionView.hidden = NO;
        [instance hideNoDataView];
        [instance.collectionView reloadData];
        if (instance.model.items.count < 1) {
            [instance showNoDataView];
        }
    } failure:^(NSError *error) {
        [instance hideLoading];
    }];
}

- (void)reloadData:(TPBarItem *)item{
    if (!item) {
        return;
    }
    self.collectionView.frame = self.view.bounds;
    self.model.showFavorite = YES;
    [self loadItems];
}

- (void)addNaviBar{
    UIView *naviBar = [TPCommonViewHelper createNavigationBar:self.region.name enableBackButton:YES];
    [self.view addSubview:naviBar];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.model.items.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TPProjectListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TPProjectListCell" forIndexPath:indexPath];
    TPProjectListItem *item = self.model.items[indexPath.row];
    [cell configWith:item];
    cell.block = ^(TPProjectListItem *item, BOOL add) {
        if (add) {
            [[TPProjectDataManager shareInstance]addFavoriteProjectId:item.pId];
        }else{
            [[TPProjectDataManager shareInstance]removeFavoriteProjectId:item.pId];
        }
        [[TPProjectDataManager shareInstance]synchronizationFavorite];
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TPProjectDetailVCL *detailVCL = (TPProjectDetailVCL *)[main instantiateViewControllerWithIdentifier:@"TPProjectDetailVCL"];
    TPProjectListItem *item = self.model.items[indexPath.row];
    detailVCL.pId = item.pId;
    [self.navigationController pushViewController:detailVCL animated:YES];
}

@end
