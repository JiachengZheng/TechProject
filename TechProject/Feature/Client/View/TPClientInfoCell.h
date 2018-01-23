//
//  TPClientInfoCell.h
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/22.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TPClientInfoItem;

typedef void(^TPClientInfoEditBlock)(TPClientInfoItem *item);
@interface TPClientInfoCell : UITableViewCell

@property (nonatomic, copy) TPClientInfoEditBlock block;

- (void)configWith:(TPClientInfoItem *)item;

@end
