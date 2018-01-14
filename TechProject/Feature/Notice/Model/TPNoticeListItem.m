//
//  TPNoticeListItem.m
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/9.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import "TPNoticeListItem.h"

@implementation TPNoticeListItem
+ (NSArray *)wrapperData:(NSArray *)arr{
    NSMutableArray *mutableArr = [NSMutableArray array];
    for (NSDictionary *dict in arr) {
        TPNoticeListItem *item = [TPNoticeListItem new];
        item.date = dict[@"date"];
        item.title = dict[@"title"];
        item.url = dict[@"url"];
        item.aId = dict[@"id"];
        item.categoryId = dict[@"category_id"];
        [mutableArr addObject:item];
    }
    return mutableArr;
}
@end
