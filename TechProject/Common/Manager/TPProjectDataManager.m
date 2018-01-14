//
//  TPProjectDataManager.m
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/10.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import "TPProjectDataManager.h"
#import "TPExcelManager.h"
@implementation TPProjectDataManager

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    static TPProjectDataManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[TPProjectDataManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadData];
    }
    return self;
}

- (void)loadData{
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"test.xls"];
    NSDictionary *dict = [[TPExcelManager shareInstance]readExcelContent:path];
    NSArray *regionArr = [dict valueForKey:@"region"] ?: @[];
    NSArray *projectArr = [dict valueForKey:@"project"]?: @[];
    
    _regionArr = regionArr;
    _projectArr = projectArr;
}

@end
