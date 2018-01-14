//
//  TPTabBarVCL.m
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/8.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import "TPTabBarVCL.h"
#import "TPTabBarAnimator.h"

@interface TPTabBarVCL()<UITabBarDelegate>
@property (nonatomic, assign) NSInteger curIndex;
@property (nonatomic, strong) TPTabBarAnimator *tabbarAnimator;
@end

@implementation TPTabBarVCL

- (void)viewDidLoad{
    [super viewDidLoad];
}

- (void)animationWithIndex:(NSInteger)index{
    self.curIndex = index;
    NSMutableArray *arr = [NSMutableArray array];
    for (UIView *view in self.tabBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            UIImageView *image = [view valueForKey:@"info"];
            [arr addObject:image];
        }
    }
    CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulse.duration = 0.2;
    pulse.fromValue = [NSNumber numberWithFloat:0.8];
    pulse.toValue= [NSNumber numberWithFloat:1.0];
    [[arr[index] layer] addAnimation:pulse forKey:nil];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSInteger index = [self.tabBar.items indexOfObject:item];
    if (self.curIndex != index) {
        [self animationWithIndex:index];
    }
}


@end
