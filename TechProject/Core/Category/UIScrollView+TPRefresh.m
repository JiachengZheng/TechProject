//
//  UIScrollView+TPRefresh.m
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/9.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import "UIScrollView+TPRefresh.h"
#import <objc/runtime.h>
static const char kRefreshHeaderKey;

@implementation UIScrollView (TPRefresh)

- (void)addRefreshHeaderWithHandle:(void (^)(void))handle{
    [self addSubview:self.refreshHeader];
    [self insertSubview:self.refreshHeader atIndex:0];
    self.refreshHeader.handle = handle;
}

- (TPRefreshHeaderView *)refreshHeader {
    TPRefreshHeaderView *refreshHeader = objc_getAssociatedObject(self, &kRefreshHeaderKey);
    if (!refreshHeader) {
        refreshHeader = [[TPRefreshHeaderView alloc]initWithFrame:CGRectMake(0, -kDefaultRefreshHeight, [UIScreen mainScreen].bounds.size.width, kDefaultRefreshHeight)];
        objc_setAssociatedObject(self, &kRefreshHeaderKey, refreshHeader, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return refreshHeader;
}

@end
