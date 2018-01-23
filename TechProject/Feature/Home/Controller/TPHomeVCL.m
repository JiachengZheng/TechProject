//
//  TPHomeVCL.m
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/8.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import "TPHomeVCL.h"
#import "TPCommonViewHelper.h"
#import "TPCommonDefine.h"
#import "TPHomeRegionCell.h"
#import <lottie-ios/Lottie/Lottie.h>
#import "TPLaunchVCL.h"
#import "TPExcelManager.h"
#import "TPHomeModel.h"
#import "TPProjectListVCL.h"
#import "TPSeachProjectVCL.h"
#import "TPSnowView.h"
#import "TPFavoriteVCL.h"
NSInteger kItemsCount = 3;

@interface TPHomeVCL ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collecitonView;
@property (nonatomic, strong) TPLaunchVCL *launchVCL;
@property (nonatomic, strong) TPHomeModel *model;
@end

@implementation TPHomeVCL

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.model = [TPHomeModel new];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadItems) name:kTPDidReadExcelContentNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置控制器图片(使用imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal,不被系统渲染成蓝色)
    self.tabBarItem.image = [[UIImage imageNamed:@"tab_home"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_home_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [self addNaviBar];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(TPScreenWidth/kItemsCount, TPScreenWidth/kItemsCount - 20);
    self.collecitonView.collectionViewLayout = layout;
    self.collecitonView.alwaysBounceVertical = YES;
    self.collecitonView.frame = CGRectMake(0, TPStatusBarAndNavigationBarHeight, TPScreenWidth, self.view.height - TPStatusBarAndNavigationBarHeight);
    
    TPLaunchVCL *launchVCL = [TPLaunchVCL new];
    [[UIApplication sharedApplication].delegate.window addSubview:launchVCL.view];
    self.launchVCL.view.frame = [UIScreen mainScreen].bounds;
    
    [self loadItems];
}

- (void)loadItems{
    if (!self.model.items || self.model.items.count < 1) {
        [self showLoading];
        [self hideNoDataView];
    }
    __weak typeof(self) instance = self;
    [self.model loadItems:nil completion:^(NSDictionary *suc) {
        [instance hideLoading];
        [instance hideNoDataView];
        [instance.collecitonView reloadData];
        if (instance.model.items.count < 1) {
            [instance showNoDataView];
        }
    } failure:^(NSError *error) {
        [instance hideLoading];
        [instance hideNoDataView];
    }];
}

- (void)addNaviBar{
    UIView *naviBar = [TPCommonViewHelper createNavigationBar:@"项目" enableBackButton:NO];
    [self.view addSubview:naviBar];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn addTarget:self action:@selector(openSearchVCL) forControlEvents:UIControlEventTouchUpInside];
    [searchBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [naviBar addSubview:searchBtn];
    searchBtn.frame = CGRectMake(TPScreenWidth - 44, 20, 44, 44);
    
    UIButton *favoriteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [favoriteBtn addTarget:self action:@selector(openFavoriteVCL) forControlEvents:UIControlEventTouchUpInside];
    [favoriteBtn setImage:[UIImage imageNamed:@"favorite"] forState:UIControlStateNormal];
    [naviBar addSubview:favoriteBtn];
    favoriteBtn.frame = CGRectMake(4, 20, 44, 44);
}

- (void)openSearchVCL{
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TPSeachProjectVCL *vcl = (TPSeachProjectVCL *)[main instantiateViewControllerWithIdentifier:@"TPSeachProjectVCL"];
    [self.navigationController pushViewController:vcl animated:YES];
}

- (void)openFavoriteVCL{
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TPFavoriteVCL *vcl = (TPFavoriteVCL *)[main instantiateViewControllerWithIdentifier:@"TPFavoriteVCL"];
    [self.navigationController pushViewController:vcl animated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.model.items.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TPHomeRegionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TPHomeRegionCell" forIndexPath:indexPath];
    TPHomeRegionItem *item = self.model.items[indexPath.row];
    [cell configWith:item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TPHomeRegionItem *item = self.model.items[indexPath.row];
    TPProjectListVCL *listVCL = (TPProjectListVCL *)[main instantiateViewControllerWithIdentifier:@"TPProjectListVCL"];
    listVCL.region = item.region;
    [self.navigationController pushViewController:listVCL animated:YES];
    self.collecitonView.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.collecitonView.userInteractionEnabled = YES;
    });
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
