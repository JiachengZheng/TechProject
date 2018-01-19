//
//  TPProjectModel.m
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/10.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import "TPProjectModel.h"
#import "TPEncodeAndDecoded.h"
@implementation TPProjectModel
ENCODED_AND_DECODED()
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.infoArr = [NSMutableArray array];
    }
    return self;
}
@end
@implementation TPProjectRegionModel
ENCODED_AND_DECODED()
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
@end
