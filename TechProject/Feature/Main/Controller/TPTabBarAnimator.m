//
//  TPTabBarAnimator.m
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/8.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import "TPTabBarAnimator.h"

@interface TPTabBarAnimator()
@end

@implementation TPTabBarAnimator
- (void)animationWithIndex:(UITabBar *)tabBar index:(NSInteger)index{
    NSMutableArray *arr = [NSMutableArray array];
    for (UIView *view in tabBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            UIImageView *image = [view valueForKey:@"info"];
            [arr addObject:image];
        }
    }
    CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulse.duration = 0.08;
    pulse.repeatCount = 1;
    pulse.autoreverses = YES;
    pulse.fromValue = [NSNumber numberWithFloat:0.7];
    pulse.toValue= [NSNumber numberWithFloat:1.3];
    for (UIImageView *imageView in arr) {
        [imageView.layer addAnimation:pulse forKey:nil];
    }
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSInteger index = [tabBar.items indexOfObject:item];
    [self animationWithIndex:tabBar index:index];
}
@end
