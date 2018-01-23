//
//  TPClientListCell.m
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/22.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import "TPClientListCell.h"
#import <YYCategories.h>
#import <lottie-ios/Lottie/Lottie.h>
#import "UIButton+TPButton.h"
#import "TPProjectDataManager.h"
@interface TPClientListCell()
@property (weak, nonatomic) IBOutlet UILabel *numberTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UILabel *projectNumber;
@property (weak, nonatomic) IBOutlet UILabel *regionLabel;
@property (weak, nonatomic) IBOutlet UILabel *clientNameLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (nonatomic, strong)LOTAnimationView *animation;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (nonatomic, strong) TPClientModel *model;

@end
@implementation TPClientListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.numberTipLabel.layer.cornerRadius = 2;
    self.numberTipLabel.clipsToBounds = YES;
    
    self.line.height = 0.5;
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 4;
    self.bgView.layer.cornerRadius = 4;
    
    self.contentView.clipsToBounds = NO;
    self.clipsToBounds = NO;
    self.contentView.layer.shadowOffset = CGSizeMake(1, 1);
    self.contentView.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.1].CGColor;
    self.contentView.layer.shadowOpacity = 1;
    
    [self.likeButton addTarget:self action:@selector(touchLikeButton:) forControlEvents:UIControlEventTouchUpInside];
    self.likeButton.hitTestEdgeInsets = UIEdgeInsetsMake(-20, -20, -20, -20);
    
    LOTAnimationView *animation = [LOTAnimationView animationNamed:@"like" inBundle:[NSBundle mainBundle]];
    animation.frame = self.likeButton.frame;
    animation.contentMode = UIViewContentModeScaleAspectFill;
    [self.bgView addSubview:animation];
    animation.backgroundColor = [UIColor clearColor];
    animation.hidden = YES;
    self.animation = animation;
    self.animation.userInteractionEnabled = NO;
}

- (void)configWith:(TPClientModel *)model{
    self.model = model;
    self.projectNumber.text = model.projectNumber;
    self.clientNameLabel.text = model.clientName;
    self.projectNameLabel.text = model.projectName;
    self.regionLabel.text = model.region;
    
    NSArray *fArr = [TPProjectDataManager shareInstance].favoriteClientsId;
    for (NSString *str in fArr) {
        if ([str isEqualToString:model.clientId]) {
            self.animation.hidden = NO;
        }
    }
}

- (void)prepareForReuse{
    [super prepareForReuse];
    self.projectNumber.text = nil;
    self.clientNameLabel.text = nil;
    self.projectNameLabel.text = nil;
    self.animation.hidden = YES;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.animation.frame = self.likeButton.frame;
    self.animation.size = CGSizeMake(self.animation.width + 36, self.animation.height + 36);
    self.animation.center = self.likeButton.center;
}

- (void)touchLikeButton:(UIButton *)sender {
    if (self.animation.hidden) {
        self.animation.hidden = NO;
        [self.animation playWithCompletion:^(BOOL animationFinished) {
            
        }];
    }else{
        self.animation.hidden = YES;
    }
    if (self.block) {
        self.block(self.model, !self.animation.hidden);
    }
}

@end
