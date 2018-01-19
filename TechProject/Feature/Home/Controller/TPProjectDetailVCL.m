//
//  TPProjectDetailVCL.m
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/15.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import "TPProjectDetailVCL.h"
#import "TPProjectDetailModel.h"
#import "TPProjectInfoCell.h"
#import "TPProjectDetailNameCell.h"
#import "UIButton+TPButton.h"
@interface TPProjectDetailVCL ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIView *naviBar;
@property (nonatomic, strong) TPProjectDetailModel *model;
@property (nonatomic, strong) UIButton *backBtn;
@end

@implementation TPProjectDetailVCL

- (void)viewDidLoad {
    [super viewDidLoad];
    self.model = [TPProjectDetailModel new];
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
    NSString *pId = self.pId ?: @"";
    [self.model loadItems:@{@"pId":pId} completion:^(NSDictionary *suc) {
        [instance hideLoading];
        [instance.tableView reloadData];
    } failure:^(NSError *error) {
        [instance hideLoading];
    }];
}

- (void)addNaviBar{
    UIView *naviBar = [TPCommonViewHelper createNavigationBar:@"项目详情" enableBackButton:YES];
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
        TPProjectInfoItem *item = self.model.items[indexPath.row];
        return item.height;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        TPProjectDetailNameCell *cell = (TPProjectDetailNameCell *)[tableView dequeueReusableCellWithIdentifier:@"TPProjectDetailNameCell" forIndexPath:indexPath];
        TPProjectInfoNameItem *item = self.model.items[indexPath.row];
        [cell configWith:item];
        return cell;
    }else{
        TPProjectInfoCell *cell = (TPProjectInfoCell *)[tableView dequeueReusableCellWithIdentifier:@"TPProjectInfoCell" forIndexPath:indexPath];
        TPProjectInfoItem *item = self.model.items[indexPath.row];
        [cell configWith:item];
        return cell;
    }
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


@end
