//
//  TPNoticeListCell.h
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/9.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPNoticeListItem.h"
#import "TPTopLeftLabel.h"
@interface TPNoticeListCell : UITableViewCell
- (void)configWith:(TPNoticeListItem *)item;
@end
