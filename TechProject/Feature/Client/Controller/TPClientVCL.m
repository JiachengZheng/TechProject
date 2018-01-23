//
//  TPClientVCL.m
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/8.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import "TPClientVCL.h"
#import "TPCommonViewHelper.h"
#import "TPClientListModel.h"
#import "TPClientListCell.h"
#import "TPClientDetailVCL.h"
#import "TPProjectDataManager.h"
#import "TPClientSearchVCL.h"
#import "TPFavoriteVCL.h"
@interface TPClientVCL ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) TPClientListModel *model;
@end

@implementation TPClientVCL

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadItems) name:TPClientDataDidChangeNotification object:nil];
    self.model = [TPClientListModel new];
    
    self.tabBarItem.image = [[UIImage imageNamed:@"tab_client"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_client_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addNaviBar];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 14;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(TPScreenWidth - 24, 140);
    layout.sectionInset = UIEdgeInsetsMake(14, 0, 14, 0);
    
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.frame = CGRectMake(0, TPStatusBarAndNavigationBarHeight, TPScreenWidth, self.view.height - TPStatusBarAndNavigationBarHeight - TPTabbarHeight - TPTabbarSafeBottomMargin);
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadItems];
}

- (void)addNaviBar{
    UIView *naviBar = [TPCommonViewHelper createNavigationBar:@"客户" enableBackButton:NO];
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
    TPClientSearchVCL *vcl = (TPClientSearchVCL *)[main instantiateViewControllerWithIdentifier:@"TPClientSearchVCL"];
    [self.navigationController pushViewController:vcl animated:YES];
}

- (void)openFavoriteVCL{
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TPFavoriteVCL *vcl = (TPFavoriteVCL *)[main instantiateViewControllerWithIdentifier:@"TPFavoriteVCL"];
    [self.navigationController pushViewController:vcl animated:YES];
}

- (void)reloadData:(TPBarItem *)item{
    if (!item) {
        return;
    }
    self.collectionView.frame = self.view.bounds;
    self.model.showFavorite = YES;
    [self loadItems];
}

- (void)loadItems{
    if (!self.model.items || self.model.items.count < 1) {
        [self showLoading];
    }
    __weak typeof(self) instance = self;
    [self.model loadItems:nil completion:^(NSDictionary *suc) {
        [instance hideLoading];
        [instance.collectionView reloadData];
        if (instance.model.items.count < 1) {
            [instance showNoDataView];
        }
    } failure:^(NSError *error) {
        [instance hideLoading];
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.model.items.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TPClientListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TPClientListCell" forIndexPath:indexPath];
    [cell configWith:self.model.items[indexPath.row]];
    cell.block = ^(TPClientModel *model, BOOL add) {
        if (add) {
            [[TPProjectDataManager shareInstance]addFavoriteClientId:model.clientId];
        }else{
            [[TPProjectDataManager shareInstance]removeFavoriteClientId:model.clientId];
        }
        [[TPProjectDataManager shareInstance]synchronizationFavorite];
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TPClientDetailVCL *detailVCL = (TPClientDetailVCL *)[main instantiateViewControllerWithIdentifier:@"TPClientDetailVCL"];
    TPClientModel *item = self.model.items[indexPath.row];
    detailVCL.client = item;
    [self.navigationController pushViewController:detailVCL animated:YES];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
