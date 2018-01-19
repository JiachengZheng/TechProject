//
//  TPProjectInfoCell.m
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/15.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import "TPProjectInfoCell.h"
#import "TPProjectDetailModel.h"
#import <YYCategories.h>
@interface TPProjectInfoCell()
@property (weak, nonatomic) IBOutlet UILabel *infoTitle;
@property (weak, nonatomic) IBOutlet UITextView *infoTextLabel;
@property (nonatomic, strong) CALayer *dotLayer;
@end

@implementation TPProjectInfoCell

- (void)awakeFromNib {
    //EB7A02
    [super awakeFromNib];
    self.infoTitle.textColor = [UIColor colorWithHexString:@"333333"];
    self.dotLayer = [CALayer layer];
    self.dotLayer.frame = CGRectMake(0, 0, 5, 5);
    self.dotLayer.backgroundColor = [UIColor colorWithHexString:@"EF8E2E"].CGColor;
    self.dotLayer.right = self.infoTitle.left - 3;
    self.dotLayer.height = self.infoTitle.height - 4;
    self.dotLayer.centerY = self.infoTitle.centerY;
    self.dotLayer.width = 4;
    [self.contentView.layer addSublayer:self.dotLayer];
    // Initialization code
}

- (void)configWith:(TPProjectInfoItem *)item{
    self.infoTitle.text = item.title;
    self.infoTextLabel.attributedText = item.info;
    self.infoTextLabel.tintColor = [UIColor colorWithHexString:@"525252"];
    [self setNeedsLayout];
}

- (void)prepareForReuse{
    [super prepareForReuse];
    self.infoTextLabel.text = nil;
    self.infoTitle.text = nil;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect rect = self.infoTextLabel.frame;
    rect.origin.y = 42;
    rect.size.width = self.contentView.width - 30;
    rect.origin.x = 16;
    rect.size.height = self.contentView.height - rect.origin.y;
    self.infoTextLabel.frame = rect;
}


@end
