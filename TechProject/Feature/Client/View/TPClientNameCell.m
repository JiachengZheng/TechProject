//
//  TPClientNameCell.m
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/22.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import "TPClientNameCell.h"
@interface TPClientNameCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectName;
@property (weak, nonatomic) IBOutlet UILabel *regionLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end

@implementation TPClientNameCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configWith:(TPClientInfoNameItem *)item{
    self.nameLabel.text = item.title;
    self.projectName.text = item.model.projectName;
    self.numberLabel.text = item.model.projectNumber;
    self.regionLabel.text = item.model.region;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
