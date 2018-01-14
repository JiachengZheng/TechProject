//
//  TPBaseModel.m
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/8.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import "TPBaseModel.h"

@implementation TPBaseModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.items = [NSMutableArray array];
    }
    return self;
}


- (void)loadItems:(NSDictionary *)dict completion:(void(^)(NSDictionary *dic))completion failure:(void(^)(NSError *error))failure{
    
}
@end
