//
//  TPLaunchVCL.m
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/9.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import "TPLaunchVCL.h"
#import <lottie-ios/Lottie/Lottie.h>
@interface TPLaunchVCL ()
@property (nonatomic, strong)LOTAnimationView *animation;
@end

@implementation TPLaunchVCL

- (void)viewDidLoad {
    [super viewDidLoad];
    LOTAnimationView *animation = [LOTAnimationView animationNamed:@"down" inBundle:[NSBundle mainBundle]];
    animation.frame = self.view.bounds;
//    animation.loopAnimation = YES;
    animation.centerX -= 15 ;
    animation.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:animation];
    animation.backgroundColor = [UIColor whiteColor];
    self.animation = animation;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addWelcomeLabel];
    // Do any additional setup after loading the view.
}

- (void)addWelcomeLabel{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, TPScreenHeight - 90, TPScreenWidth, 50)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor colorWithHexString:@"5C5D5D"];
    label.text = @"欢迎回来";
    [self.view addSubview:label];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
    [self.animation playWithCompletion:^(BOOL animationFinished) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO animated:NO];
        [UIView animateWithDuration:0.4 animations:^{
            self.view.alpha = 0;
        }completion:^(BOOL finished) {
            [self.animation removeFromSuperview];
            self.animation = nil;
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
        }];
    }];
}

- (void)dealloc{
    
}

@end
