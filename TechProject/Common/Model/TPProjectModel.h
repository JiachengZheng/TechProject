//
//  TPProjectModel.h
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/10.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPProjectRegionModel.h"
@interface TPProjectModel : NSObject
@property (nonatomic, strong) NSMutableArray *infoArr;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pId;
@property (nonatomic, strong) TPProjectRegionModel *region;
@end


