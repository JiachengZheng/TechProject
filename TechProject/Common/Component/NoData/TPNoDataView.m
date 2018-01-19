//
//  TPNoDataView.m
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/18.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import "TPNoDataView.h"
#import "TPCommonDefine.h"
#import <YYCategories.h>
#import <lottie-ios/Lottie/Lottie.h>

@interface TPNoDataView()
@property (nonatomic, strong) LOTAnimationView *animationView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation TPNoDataView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self uiInit];
    }
    return self;
}

- (void)uiInit{
    LOTAnimationView *animation = [LOTAnimationView animationNamed:@"empty_status" inBundle:[NSBundle mainBundle]];
    animation.size = CGSizeMake(200, 200);
    animation.centerX = self.width/2;
    animation.centerY = self.height/2 - 50;
    animation.contentMode = UIViewContentModeScaleAspectFit;
    _animationView = animation;
    [self addSubview:_animationView];
    animation.loopAnimation = YES;
    
    [self addLabel];
}

- (void)addLabel{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, _animationView.centerY + 45, TPScreenWidth, 50)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor colorWithHexString:@"949494"];
    label.text = @"空空如也";
    [self addSubview:label];
}

- (void)show{
    self.hidden = NO;
    if (!self.animationView.isAnimationPlaying) {
        [self.animationView play];
    }
}

- (void)hide{
    [_animationView stop];
    self.hidden = YES;
}


@end
