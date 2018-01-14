//
//  TPProjectListCell.h
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/10.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPProjectListModel.h"
@interface TPProjectListCell : UICollectionViewCell
- (void)configWith:(TPProjectListItem *)item;
@end
