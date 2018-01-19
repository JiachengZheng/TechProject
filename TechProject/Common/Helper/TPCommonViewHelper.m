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
    naviBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleLeftMargin;
    CALayer *line = [CALayer layer];
    line.backgroundColor = [UIColor colorWithHexString:@"d9d9d9"].CGColor;
//    [naviBar.layer addSublayer:line];
    line.frame = CGRectMake(0, naviBar.height-0.5, naviBar.width, 0.5);
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, TPStatusBarHeight, 100, TPNavigationBarHeight)];
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.textColor = [UIColor whiteColor]; //[UIColor colorWithHexString:@"3d3d3d"];
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
    
    // 背景条
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = naviBar.bounds;
    gradient.colors = @[(id)[UIColor colorWithHexString:@"508CFF"].CGColor,
                        (id)[UIColor colorWithHexString:@"26C4FD"].CGColor,];
    gradient.startPoint = CGPointMake(0, 0.4);
    gradient.endPoint = CGPointMake(1, 0.6);
//    gradient.locations = @[@0, @0.45, @1];
    [naviBar.layer insertSublayer:gradient atIndex:0];
    
    naviBar.layer.shadowOffset = CGSizeMake(0, 1);
    naviBar.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.2].CGColor;
    naviBar.layer.shadowOpacity = 1;
    return naviBar;
}

+ (void)backAction{
    UINavigationController *navi = (UINavigationController *)([UIApplication sharedApplication].delegate.window.rootViewController);
    [navi popViewControllerAnimated:YES];
}
@end
