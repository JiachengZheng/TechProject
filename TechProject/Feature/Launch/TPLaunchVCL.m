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
    LOTAnimationView *animation = [LOTAnimationView animationNamed:@"emoji_wink" inBundle:[NSBundle mainBundle]];
    animation.frame = self.view.bounds;
    animation.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:animation];
    animation.backgroundColor = [UIColor whiteColor];
    self.animation = animation;
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
    [self.animation playWithCompletion:^(BOOL animationFinished) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO animated:NO];
        [UIView animateWithDuration:0.7 animations:^{
            self.view.alpha = 0;
            self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
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
