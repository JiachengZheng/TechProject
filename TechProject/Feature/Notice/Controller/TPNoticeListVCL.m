//
//  TPNoticeListVCL.m
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/9.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import "TPNoticeListVCL.h"
#import "TPNoticeListModel.h"
#import "TPNoticeListCell.h"
#import "TPNoticeListItem.h"
#import "TPNoticeDetailVCL.h"
#import <SafariServices/SafariServices.h>
@interface TPNoticeListVCL ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) TPNoticeListModel *model;
@end

@implementation TPNoticeListVCL

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    NSDictionary *titleMap = @{
                               @1: @"北京科委",
                               @2: @"石家庄科技",
                               };
    UIView *naviBar = [TPCommonViewHelper createNavigationBar:titleMap[self.categoryId] enableBackButton:YES];
    [self.view addSubview:naviBar];
    self.tableView.frame = CGRectMake(0, TPStatusBarAndNavigationBarHeight, TPScreenWidth, TPScreenHeight - TPStatusBarAndNavigationBarHeight - TPTabbarSafeBottomMargin);
    self.model = [TPNoticeListModel new];
    [self loadData];
    __weak typeof(self) instance = self;
    [self.tableView addRefreshHeaderWithHandle:^{
        [instance loadData];
    }];
    // Do any additional setup after loading the view.
}

- (void)loadData{
    if (!self.model.items || self.model.items.count < 1) {
        [self showLoading];
    }
    __weak typeof(self) instance = self;
    [self.model loadItems:@{@"cid": self.categoryId} completion:^(NSDictionary *dict) {
        [instance.tableView reloadData];
        [instance hideLoading];
        [instance.tableView.refreshHeader endRefreshing];
    } failure:^(NSError *error) {
        [instance hideLoading];
        [instance.tableView.refreshHeader endRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TPNoticeListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TPNoticeListCell" forIndexPath:indexPath];
    TPNoticeListItem *item = self.model.items[indexPath.row];
    [cell configWith:item];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    TPNoticeListItem *item = self.model.items[indexPath.row];
    NSURL *url = [NSURL URLWithString:item.url];
    SFSafariViewController *safariVc = [[SFSafariViewController alloc] initWithURL:url];
    [self presentViewController:safariVc animated:YES completion:nil];
    
//    TPNoticeDetailVCL *listVCL = [TPNoticeDetailVCL new];
//    listVCL.urlString = item.url;
//    [self.navigationController pushViewController:listVCL animated:YES];
}

@end
