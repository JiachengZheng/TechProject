//
//  TPBaseViewController.m
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/8.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import "TPBaseViewController.h"
#import <MBProgressHUD.h>
@interface TPBaseViewController ()<UIGestureRecognizerDelegate>

@end

@implementation TPBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    // Do any additional setup after loading the view.
}

- (void)showLoading{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)hideLoading{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

@end
