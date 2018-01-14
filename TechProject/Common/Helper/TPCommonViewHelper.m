//
//  TPCommonViewHelper.m
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/8.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import "TPCommonViewHelper.h"
#import "TPCommonDefine.h"
#import <YYCategories.h>
@implementation TPCommonViewHelper

+ (UIView *)createNavigationBar:(NSString *)title enableBackButton:(BOOL)enableBackButton{
    UIView *naviBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TPScreenWidth, TPStatusBarAndNavigationBarHeight)];
    naviBar.backgroundColor = [UIColor whiteColor];
    
    CALayer *line = [CALayer layer];
    line.backgroundColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
    [naviBar.layer addSublayer:line];
    line.frame = CGRectMake(0, naviBar.height-0.5, naviBar.width, 0.5);
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, TPStatusBarHeight, 100, TPNavigationBarHeight)];
    titleLabel.text = title;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textColor = [UIColor colorWithHexString:@"3d3d3d"];
    [titleLabel sizeToFit];
    titleLabel.centerX = naviBar.centerX;
    titleLabel.centerY = TPNavigationBarHeight/2 + TPStatusBarHeight;
    [naviBar addSubview:titleLabel];
    
    if (enableBackButton) {
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0, 20, 44, 44);
        [naviBar addSubview:backBtn];
        backBtn.backgroundColor = [UIColor clearColor];
        [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return naviBar;
}

+ (void)backAction{
    UINavigationController *navi = (UINavigationController *)([UIApplication sharedApplication].delegate.window.rootViewController);
    [navi popViewControllerAnimated:YES];
}
@end
