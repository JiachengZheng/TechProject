//
//  TPNoticeCategoryItem.m
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/9.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import "TPNoticeCategoryItem.h"

@implementation TPNoticeCategoryItem
+ (NSArray *)wrapperData:(NSArray *)arr{
    NSMutableArray *mutableArr = [NSMutableArray array];
    for (NSDictionary *dict in arr) {
        TPNoticeCategoryItem *item = [TPNoticeCategoryItem new];
        item.url = dict[@"url"];
        item.cId = dict[@"id"];
        item.name = dict[@"name"];
        [mutableArr addObject:item];
    }
    return mutableArr;
}
@end
