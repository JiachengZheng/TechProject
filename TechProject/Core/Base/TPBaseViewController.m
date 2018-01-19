//
//  TPBaseViewController.m
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/8.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import "TPBaseViewController.h"
#import <MBProgressHUD.h>
#import "TPSnowView.h"
#import "TPNoDataView.h"
@interface TPBaseViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) TPNoDataView *noDataView;
@end

@implementation TPBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController setNavigationBarHidden:YES];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    if(@available(iOS 11.0, *)) {
        [[UIScrollView appearance]setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL) animated{
    [super viewDidAppear:animated];
    [self.view becomeFirstResponder];
}

-(void)viewDidDisappear:(BOOL) animated{
    [super viewDidDisappear:animated];
    [self.view resignFirstResponder];
}

- (void)showLoading{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)hideLoading{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)showNoDataView{
    if (!_noDataView) {
        _noDataView = [[TPNoDataView alloc]initWithFrame:CGRectMake(0, TPStatusBarAndNavigationBarHeight, TPScreenWidth, self.view.height - TPStatusBarAndNavigationBarHeight)];
        [self.view addSubview:_noDataView];
    }
    [self.view bringSubviewToFront:_noDataView];
    [_noDataView show];
}

- (void)hideNoDataView{
    [_noDataView hide];
}

#pragma mark 运动开始
-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if (motion==UIEventSubtypeMotionShake) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [TPSnowView show];
        });
    }
}

@end
