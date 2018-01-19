//
//  TPProjectInfoCell.h
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/15.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TPProjectInfoItem;
@interface TPProjectInfoCell : UITableViewCell
- (void)configWith:(TPProjectInfoItem *)item;
@end
