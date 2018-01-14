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
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

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
    }
    __weak typeof(self) instance = self;
    [self.model loadItems:nil completion:^(NSDictionary *suc) {
        [instance hideLoading];
        [instance.collecitonView reloadData];
    } failure:^(NSError *error) {
        [instance hideLoading];
    }];
}

- (void)addNaviBar{
    UIView *naviBar = [TPCommonViewHelper createNavigationBar:@"项目" enableBackButton:NO];
    [self.view addSubview:naviBar];
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
}


@end
