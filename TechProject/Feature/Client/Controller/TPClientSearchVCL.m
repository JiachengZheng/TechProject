//
//  TPClientSearchVCL.m
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/23.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import "TPClientSearchVCL.h"
#import "TPProjectDataManager.h"
#import "TPCommonDefine.h"
#import "TPProjectDetailVCL.h"
#import "TPClientListCell.h"
#import <YYCategories.h>
#import "TPClientModel.h"
#import "TPClientDetailVCL.h"
@interface TPClientSearchVCL ()<UISearchResultsUpdating,UICollectionViewDelegate,UICollectionViewDataSource, UISearchBarDelegate>
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSArray *clientArr;
@property (nonatomic, strong) NSArray *filterArr;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) UIView *naviBar;
@end

@implementation TPClientSearchVCL

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _clientArr = [TPProjectDataManager shareInstance].clientArr;

    [self addNaviBar];
    [self addSearchController];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 14;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(TPScreenWidth - 24, 140);
    layout.sectionInset = UIEdgeInsetsMake(14 + 50, 0, 14, 0);
    
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.frame = CGRectMake(0, TPStatusBarAndNavigationBarHeight, TPScreenWidth, self.view.height - TPStatusBarAndNavigationBarHeight - TPTabbarSafeBottomMargin);
    [self.view bringSubviewToFront:self.collectionView];
}

- (void)addSearchController{
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    _searchController.hidesNavigationBarDuringPresentation=NO;
    self.searchController.searchBar.delegate = self;
    [self.searchController.searchBar sizeToFit];
    self.definesPresentationContext = YES;
    [self.searchController.searchBar setContentMode:UIViewContentModeLeft];
    self.searchController.searchBar.backgroundColor = [UIColor whiteColor];
    self.searchController.searchBar.barTintColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    self.searchController.searchBar.searchBarStyle  = UISearchBarStyleMinimal;
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTintColor:[UIColor colorWithHexString:@"b0b0b0"]];
    [self.collectionView addSubview:self.searchController.searchBar];
}

- (void)addNaviBar{
    UIView *naviBar = [TPCommonViewHelper createNavigationBar:@"搜索" enableBackButton:YES];
    [self.view addSubview:naviBar];
    self.naviBar = naviBar;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.searchBar resignFirstResponder];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (!self.searchController.active) {
        return _clientArr.count;
    } else {
        return _filterArr.count;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TPClientListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TPClientListCell" forIndexPath:indexPath];
    
    if (!self.searchController.active || _filterArr.count == 0) {
        TPClientModel *model = _clientArr[indexPath.row];
        [cell configWith:model];
    } else {
        TPClientModel *model = _filterArr[indexPath.row];
        [cell configWith:model];
    }
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TPClientDetailVCL *detailVCL = (TPClientDetailVCL *)[main instantiateViewControllerWithIdentifier:@"TPClientDetailVCL"];
    if (!self.searchController.active) {
        TPClientModel *model = _clientArr[indexPath.row];
        detailVCL.client = model;
    } else {
        TPClientModel *model = _filterArr[indexPath.row];
        detailVCL.client = model;
    }
    [self.navigationController pushViewController:detailVCL animated:YES];
}

- (void)resetSearchStatusTableViewFrame{
    CGRect tableFrame = self.collectionView.frame;
    tableFrame.origin.y = TPStatusBarHeight;
    tableFrame.size.height = self.view.frame.size.height -tableFrame.origin.y;
    [UIView animateWithDuration:0.25 animations:^{
        self.collectionView.frame = tableFrame;
    }];
    [self.view bringSubviewToFront:self.collectionView];
}

- (void)resetNormalStatusTableViewFrame{
    CGRect tableFrame = self.collectionView.frame;
    tableFrame.origin.y = TPStatusBarAndNavigationBarHeight;
    tableFrame.size.height = self.view.frame.size.height - tableFrame.origin.y;
    [UIView animateWithDuration:0.25 animations:^{
        self.collectionView.frame = tableFrame;
    }];
    [self.view bringSubviewToFront:self.naviBar];
}

#pragma mark - searchBar delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self resetSearchStatusTableViewFrame];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.collectionView reloadData];
    [self resetNormalStatusTableViewFrame];
}

#pragma mark - searchController delegate
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"clientName CONTAINS[c] %@", self.searchController.searchBar.text];
    _filterArr = [_clientArr filteredArrayUsingPredicate:pred];
    if (_filterArr.count > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }
}

@end
