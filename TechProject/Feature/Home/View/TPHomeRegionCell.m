//
//  TPHomeRegionCell.m
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/9.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import "TPHomeRegionCell.h"
#import <YYCategories.h>
@interface TPHomeRegionCell ()
@property (nonatomic, strong) UIImageView *fileImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation TPHomeRegionCell

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initUIComponent];
    }
    return self;
}

- (void)initUIComponent{
    self.fileImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_file"]];
    self.fileImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.fileImageView.layer.shadowOffset = CGSizeMake(0, 1);
    self.fileImageView.layer.shadowRadius = 1.0f;
    self.fileImageView.layer.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.2f].CGColor;
    self.fileImageView.layer.shadowOpacity = 1.f;
    [self.contentView addSubview:self.fileImageView];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"383838"];
    self.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.text = @"地区";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)configWith:(TPHomeRegionItem *)item{
    self.titleLabel.text = item.regionName;
}

- (void)prepareForReuse{
    self.titleLabel.text = nil;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.fileImageView.size = CGSizeMake(self.contentView.width/2.1, self.contentView.width/2.1);
    self.fileImageView.centerY = self.contentView.centerY - 10;
    self.fileImageView.centerX = self.contentView.centerX;
    
    self.titleLabel.top = self.fileImageView.bottom;
    self.titleLabel.width = self.contentView.width;
    self.titleLabel.height = 20;
}


@end
