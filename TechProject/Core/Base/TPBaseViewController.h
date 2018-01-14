//
//  TPBaseViewController.h
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/8.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPCommonViewHelper.h"
#import "TPCommonDefine.h"
#import <YYCategories.h>
#import "UIScrollView+TPRefresh.h"
@interface TPBaseViewController : UIViewController
- (void)showLoading;

- (void)hideLoading;
@end
