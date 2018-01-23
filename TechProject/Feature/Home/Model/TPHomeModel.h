//
//  TPHomeModel.h
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/8.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import "TPBaseModel.h"
#import "TPProjectModel.h"
#import "TPProjectRegionModel.h"
@interface TPHomeRegionItem: NSObject
@property (nonatomic, copy)NSString *regionName;
@property (nonatomic, strong) TPProjectRegionModel *region;
@end

@interface TPHomeModel : TPBaseModel

@end
