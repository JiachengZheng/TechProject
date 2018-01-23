//
//  TPClientDetailVCL.m
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/22.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import "TPClientDetailVCL.h"
#import "TPClientDetailModel.h"
#import "UIButton+TPButton.h"
#import "TPClientInfoCell.h"
#import "TPClientNameCell.h"
#import "TPClientInfoEditVCL.h"
#import "TPProjectDataManager.h"
@interface TPClientDetailVCL ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIView *naviBar;
@property (nonatomic, strong) TPClientDetailModel *model;
@property (nonatomic, strong) UIButton *backBtn;
@end

@implementation TPClientDetailVCL

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadItems) name:TPClientDataDidChangeNotification object:nil];
    self.model = [TPClientDetailModel new];
    [self addNaviBar];
    [self loadItems];
    [self addBackButton];
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)addBackButton{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(7, 27, 30, 30);
    [self.view addSubview:backBtn];
    backBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -10);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setImage:[UIImage imageNamed:@"white_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.backBtn = backBtn;
}

- (void)backAction{
    UINavigationController *navi = (UINavigationController *)([UIApplication sharedApplication].delegate.window.rootViewController);
    [navi popViewControllerAnimated:YES];
}

- (void)loadItems{
    if (!self.model.items || self.model.items.count < 1) {
        [self showLoading];
    }
    __weak typeof(self) instance = self;
    [self.model loadItems:@{@"client":self.client} completion:^(NSDictionary *suc) {
        [instance hideLoading];
        [instance.tableView reloadData];
    } failure:^(NSError *error) {
        [instance hideLoading];
    }];
}

- (void)addNaviBar{
    UIView *naviBar = [TPCommonViewHelper createNavigationBar:@"客户详情" enableBackButton:YES];
    self.naviBar = naviBar;
    naviBar.alpha = 0;
    [self.view addSubview:naviBar];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 260;
    }else{
        TPClientInfoItem *item = self.model.items[indexPath.row];
        return item.height;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        TPClientNameCell *cell = (TPClientNameCell *)[tableView dequeueReusableCellWithIdentifier:@"TPClientNameCell" forIndexPath:indexPath];
        TPClientInfoNameItem *item = self.model.items[indexPath.row];
        [cell configWith:item];
        return cell;
    }else{
        TPClientInfoCell *cell = (TPClientInfoCell *)[tableView dequeueReusableCellWithIdentifier:@"TPClientInfoCell" forIndexPath:indexPath];
        TPClientInfoItem *item = self.model.items[indexPath.row];
        [cell configWith:item];
        __weak typeof(self) instance = self;
        cell.block = ^(TPClientInfoItem *item) {
            [instance openEditVCL:item];
        };
        return cell;
    }
}

- (void)openEditVCL:(TPClientInfoItem *)item{
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TPClientInfoEditVCL *detailVCL = (TPClientInfoEditVCL *)[main instantiateViewControllerWithIdentifier:@"TPClientInfoEditVCL"];
    detailVCL.client = self.client;
    detailVCL.editType = [item.title substringToIndex:item.title.length - 1];
    detailVCL.editValue = item.info.string;
    [self.navigationController pushViewController:detailVCL animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat y = scrollView.contentOffset.y;
    CGFloat height = 150;
    if (y<height) {
        self.backBtn.alpha = 1 - y/height;
        self.naviBar.alpha = y/height;
    }else{
        self.naviBar.alpha = 1;
        self.backBtn.alpha = 0;
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
