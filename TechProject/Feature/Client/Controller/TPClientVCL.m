//
//  TPClientVCL.m
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/8.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import "TPClientVCL.h"
#import "TPCommonViewHelper.h"
@interface TPClientVCL ()

@end

@implementation TPClientVCL

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarItem.image = [[UIImage imageNamed:@"tab_client"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_client_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addNaviBar];
    [self showNoDataView];
    // Do any additional setup after loading the view.
}

- (void)addNaviBar{
    UIView *naviBar = [TPCommonViewHelper createNavigationBar:@"客户" enableBackButton:NO];
    [self.view addSubview:naviBar];
}

@end
