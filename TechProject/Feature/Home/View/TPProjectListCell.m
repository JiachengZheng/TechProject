//
//  TPProjectListCell.m
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/10.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import "TPProjectListCell.h"
#import "TPTopLeftLabel.h"
#import "UIButton+TPButton.h"
#import <lottie-ios/Lottie/Lottie.h>

@interface TPProjectListCell()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet TPTopLeftLabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (nonatomic, strong)LOTAnimationView *animation;
@property (nonatomic, strong) TPProjectListItem *item;
@end

@implementation TPProjectListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 5;
    self.bgView.layer.cornerRadius = 5;
    self.bgView.clipsToBounds = YES;
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.contentView.clipsToBounds = NO;
    self.clipsToBounds = NO;
    self.contentView.layer.shadowOffset = CGSizeMake(1, 1);
    self.contentView.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.1].CGColor;
    self.contentView.layer.shadowOpacity = 1;
    
    self.likeButton.hitTestEdgeInsets = UIEdgeInsetsMake(-20, -20, -40, -40);
    
    self.leftView.backgroundColor = TPRandomColor;
    
    [CATransaction begin];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.leftView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.leftView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.leftView.layer.mask = maskLayer;
    self.leftView.layer.masksToBounds = YES;
    
    [CATransaction commit];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.animation.frame = self.likeButton.frame;
    self.animation.size = CGSizeMake(self.animation.width + 36, self.animation.height + 36);
    self.animation.center = self.likeButton.center;
}

- (void)configWith:(TPProjectListItem *)item{
    self.item = item;
    self.nameLabel.text = item.text;
    if (!self.animation) {
        LOTAnimationView *animation = [LOTAnimationView animationNamed:@"like" inBundle:[NSBundle mainBundle]];
        animation.frame = self.likeButton.frame;
        animation.contentMode = UIViewContentModeScaleAspectFill;
        [self.bgView addSubview:animation];
        animation.backgroundColor = [UIColor clearColor];
        animation.hidden = YES;
        self.animation = animation;
        self.animation.userInteractionEnabled = NO;
    }
    if (item.isFavorite) {
        self.animation.hidden = NO;
    }
}

- (IBAction)touchLikeButton:(UIButton *)sender {
    if (self.animation.hidden) {
        self.animation.hidden = NO;
        [self.animation playWithCompletion:^(BOOL animationFinished) {
            
        }];
    }else{
        self.animation.hidden = YES;
    }
    self.item.isFavorite = !self.animation.hidden;
    if (self.block) {
        self.block(self.item, !self.animation.hidden);
    }
}

- (void)prepareForReuse{
    [super prepareForReuse];
    self.nameLabel.text = @"";
    self.animation.hidden = YES;
}

@end
