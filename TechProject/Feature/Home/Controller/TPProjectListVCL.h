//
//  TPProjectListVCL.h
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/10.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import "TPBaseViewController.h"
#import "TPProjectModel.h"
#import "TPProjectRegionModel.h"
#import "TPBarItem.h"
@interface TPProjectListVCL : TPBaseViewController
@property (nonatomic, strong) TPProjectRegionModel *region;
- (void)reloadData:(TPBarItem *)item;
@end
