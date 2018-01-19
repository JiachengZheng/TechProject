//
//  TPProjectListModel.m
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/10.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import "TPProjectListModel.h"
#import "TPProjectDataManager.h"
@implementation TPProjectListModel
- (void)loadItems:(NSDictionary *)dict completion:(void (^)(NSDictionary *))completion failure:(void (^)(NSError *))failure{
    NSString *rId = [dict valueForKey:@"rId"] ?: @"";
    NSArray *pArr = [TPProjectDataManager shareInstance].projectArr;
    NSMutableArray *arr = [NSMutableArray array];
    for (TPProjectModel *model in pArr) {
        if ([model.region.regionId isEqualToString:rId]) {
            TPProjectListItem *item = [TPProjectListItem new];
            item.text = model.name;
            item.pId = model.pId;
            [arr addObject:item];
        }
    }
    self.items = arr;
    completion(nil);
}
@end

@implementation TPProjectListItem

@end


