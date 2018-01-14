//
//  UIScrollView+TPRefresh.h
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/9.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPRefreshHeaderView.h"

#define kDefaultRefreshHeight 45.f

@interface UIScrollView (TPRefresh)
@property (nonatomic, readonly) TPRefreshHeaderView *refreshHeader;

- (void)addRefreshHeaderWithHandle:(void (^)(void))handle;
@end
