//
//  TPNoticeCategoryCell.m
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/9.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import "TPNoticeCategoryCell.h"
#import <YYCategories.h>
@interface TPNoticeCategoryCell()
@property (nonatomic, strong) UIImageView *notifyImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@end
@implementation TPNoticeCategoryCell
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initUIComponent];
    }
    return self;
}

- (void)initUIComponent{
    self.notifyImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_notify"]];
    self.notifyImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.notifyImageView];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"383838"];
    self.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)setText:(NSString *)text{
    _text = text;
    self.titleLabel.text = text;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.notifyImageView.size = CGSizeMake(self.contentView.width/2.2, self.contentView.width/2.2);
    self.notifyImageView.centerY = self.contentView.centerY - 10;
    self.notifyImageView.centerX = self.contentView.centerX;
    
    self.titleLabel.top = self.notifyImageView.bottom + 6;
    self.titleLabel.width = self.contentView.width;
    self.titleLabel.height = 20;
}

@end
