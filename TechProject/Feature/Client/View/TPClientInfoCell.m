//
//  TPClientInfoCell.m
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/22.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import "TPClientInfoCell.h"
#import <YYCategories.h>
#import "TPClientDetailModel.h"
@interface TPClientInfoCell()
@property (weak, nonatomic) IBOutlet UILabel *infoTitle;
@property (weak, nonatomic) IBOutlet UITextView *infoTextLabel;
@property (nonatomic, strong) CALayer *dotLayer;
@property (nonatomic, strong) TPClientInfoItem *item;
@end
@implementation TPClientInfoCell

- (void)awakeFromNib {
    //EB7A02
    [super awakeFromNib];
    self.infoTitle.textColor = [UIColor colorWithHexString:@"333333"];
    [CATransaction begin];
    self.dotLayer = [CALayer layer];
    self.dotLayer.frame = CGRectMake(0, 0, 5, 5);
    self.dotLayer.backgroundColor = [UIColor colorWithHexString:@"106ADB"].CGColor;
    self.dotLayer.right = self.infoTitle.left - 3;
    self.dotLayer.height = self.infoTitle.height - 4;
    self.dotLayer.centerY = self.infoTitle.centerY;
    self.dotLayer.width = 4;
    [self.contentView.layer addSublayer:self.dotLayer];
    [CATransaction commit];
    // Initialization code
}

- (void)configWith:(TPClientInfoItem *)item{
    _item = item;
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

- (IBAction)clickEdit:(id)sender {
    if (self.block) {
        self.block(_item);
    }
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
