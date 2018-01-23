//
//  JCPageSlideBarCell.m
//  JCPageControllerDemo
//
//  Created by 郑嘉成 on 2017/2/10.
//  Copyright © 2017年 ZhengJiacheng. All rights reserved.
//

#import "JCPageSlideBarCell.h"
#import <YYCategories.h>
@interface JCPageSlideBarCell()
@property (nonatomic, strong) UILabel *label;
@end

@implementation JCPageSlideBarCell

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.clipsToBounds = YES;
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc]initWithFrame:self.bounds];
        [self.contentView addSubview:_label];
        _label.font = [UIFont systemFontOfSize:14];
        _label.textColor = [UIColor colorWithHexString:@"333333"];
        _label.tag = kSlideBarCellTitleTag;
        _label.textAlignment = NSTextAlignmentCenter;
        _label.backgroundColor = [UIColor whiteColor];
    }
    return  _label;
}

- (void)setText:(NSString *)text{
    _text = text;
    self.label.text = text;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        self.label.textColor = kTitleSelectedColor;
    }else{
        self.label.textColor = kTitleNormalColor;
    }
}

- (void)prepareForReuse{
    self.label.text = @"";
    self.label.textColor = [UIColor blackColor];
}
@end
