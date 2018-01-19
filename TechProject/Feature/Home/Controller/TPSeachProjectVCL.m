//
//  TPSeachProjectVCL.m
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/18.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import "TPSeachProjectVCL.h"
#import "TPProjectDataManager.h"
#import "TPCommonDefine.h"
#import "TPProjectDetailVCL.h"
@interface TPSeachProjectVCL ()<UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *projectArr;
@property (nonatomic, strong) NSArray *filterArr;
@property (nonatomic, strong) UIView *naviBar;
@end

@implementation TPSeachProjectVCL

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _projectArr = [TPProjectDataManager shareInstance].projectArr;
    
    [self addNaviBar];
    [self addTableView];
    [self addSearchController];
}

- (void)addTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, TPStatusBarAndNavigationBarHeight, TPScreenWidth, TPScreenHeight - TPStatusBarAndNavigationBarHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
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
    self.tableView.tableHeaderView = self.searchController.searchBar;
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

- (void)resetSearchStatusTableViewFrame{
    CGRect tableFrame = self.tableView.frame;
    tableFrame.origin.y = TPStatusBarHeight;
    tableFrame.size.height = self.view.frame.size.height -tableFrame.origin.y;
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.frame = tableFrame;
    }];
}

- (void)resetNormalStatusTableViewFrame{
    CGRect tableFrame = self.tableView.frame;
    tableFrame.origin.y = TPStatusBarAndNavigationBarHeight;
    tableFrame.size.height = self.view.frame.size.height - tableFrame.origin.y;
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.frame = tableFrame;
    }];
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.searchController.active) {
        return _projectArr.count;
    } else {
        return _filterArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (!self.searchController.active) {
        TPProjectModel *model = _projectArr[indexPath.row];
        cell.textLabel.text = model.name;
    } else {
        TPProjectModel *model = _filterArr[indexPath.row];
        cell.textLabel.text = model.name;
    }
    cell.textLabel.textColor = [UIColor colorWithHexString:@"0x4a4a4a"];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TPProjectDetailVCL *detailVCL = (TPProjectDetailVCL *)[main instantiateViewControllerWithIdentifier:@"TPProjectDetailVCL"];
    if (!self.searchController.active) {
        TPProjectModel *model = _projectArr[indexPath.row];
        detailVCL.pId = model.pId;
    } else {
        TPProjectModel *model = _filterArr[indexPath.row];
        detailVCL.pId = model.pId;
    }
    [self.navigationController pushViewController:detailVCL animated:YES];
}

#pragma mark - searchBar delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self resetSearchStatusTableViewFrame];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self resetNormalStatusTableViewFrame];
}

#pragma mark - searchController delegate
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"name CONTAINS[c] %@", self.searchController.searchBar.text];
    _filterArr = [_projectArr filteredArrayUsingPredicate:pred];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

@end
