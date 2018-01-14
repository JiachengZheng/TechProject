//
//  TPNoticeListCell.m
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/9.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import "TPNoticeListCell.h"
#import "TPNoticeListItem.h"
#import <YYCategories.h>

@interface TPNoticeListCell()
@property (weak, nonatomic) IBOutlet TPTopLeftLabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@end

@implementation TPNoticeListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    self.bgView.layer.cornerRadius = 5;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.bgView.layer.shadowOffset = CGSizeMake(1, 1);
    self.bgView.layer.shadowRadius = 3.0f;
    self.bgView.layer.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.1f].CGColor;
    self.bgView.layer.shadowOpacity = 0.8f;
    // Initialization code
}

- (void)configWith:(TPNoticeListItem *)item{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    NSDictionary *attributes = @{
                                 NSParagraphStyleAttributeName:paragraphStyle,
                                 };
    self.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:item.title attributes:attributes];;
    self.dateLabel.text = item.date;
}

@end
