//
//  TPProjectListCell.h
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/10.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPProjectListModel.h"

typedef void(^TPProjectListFavoriteBlock)(TPProjectListItem *item, BOOL add);

@interface TPProjectListCell : UICollectionViewCell

@property (nonatomic, copy) TPProjectListFavoriteBlock block;

- (void)configWith:(TPProjectListItem *)item;
@end
