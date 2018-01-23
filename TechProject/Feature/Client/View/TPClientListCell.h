//
//  TPClientListCell.h
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/22.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPClientModel.h"
typedef void(^TPClientListFavoriteBlock)(TPClientModel *model, BOOL add);
@interface TPClientListCell : UICollectionViewCell
- (void)configWith:(TPClientModel *)model;
@property (nonatomic, copy) TPClientListFavoriteBlock block;
@end
