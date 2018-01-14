//
//  TPProjectListCell.m
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/10.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import "TPProjectListCell.h"
#import "TPTopLeftLabel.h"
@interface TPProjectListCell()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet TPTopLeftLabel *nameLabel;

@end

@implementation TPProjectListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 7;
    self.bgView.clipsToBounds = NO;
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.contentView.clipsToBounds = NO;
    self.clipsToBounds = NO;
    self.contentView.layer.shadowOffset = CGSizeMake(1, 1);
    self.contentView.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.1].CGColor;
    self.contentView.layer.shadowOpacity = 1;
}

- (void)configWith:(TPProjectListItem *)item{
    self.nameLabel.text = item.text;
}

- (void)prepareForReuse{
    [super prepareForReuse];
    self.nameLabel.text = @"";
}

@end
