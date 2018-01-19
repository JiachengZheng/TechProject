//
//  TPProjectDataManager.h
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/10.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPProjectModel.h"
@interface TPProjectDataManager : NSObject

@property (nonatomic, copy, readonly)NSArray <TPProjectRegionModel *>*regionArr;
@property (nonatomic, copy, readonly)NSArray <TPProjectModel *>*projectArr;

+ (instancetype)shareInstance;
- (void)addProjectFromExcel:(NSString *)path;
- (void)loadData;
@end
