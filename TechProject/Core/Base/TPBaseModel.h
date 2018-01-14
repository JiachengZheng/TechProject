//
//  TPBaseModel.h
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/8.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPCommonViewHelper.h"
#import "TPCommonDefine.h"
#import <YYCategories.h>
@interface TPBaseModel : NSObject

@property (nonatomic, strong) NSArray *items;


- (void)loadItems:(NSDictionary *)dict completion:(void(^)(NSDictionary *dic))completion failure:(void(^)(NSError *error))failure;

@end
