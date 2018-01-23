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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *rId = [dict valueForKey:@"rId"] ?: @"";
        NSArray *pArr = [TPProjectDataManager shareInstance].projectArr;
        NSArray *fArr = [TPProjectDataManager shareInstance].favoriteProjectId;
        NSMutableArray *arr = [NSMutableArray array];
        if (self.showFavorite) {
            for (TPProjectModel *model in pArr) {
                TPProjectListItem *item = [TPProjectListItem new];
                item.text = model.name;
                item.pId = model.pId;
                if ([fArr containsObject:model.pId]) {
                    item.isFavorite = YES;
                }
                if (item.isFavorite) {
                    [arr addObject:item];
                }
            }
        }else{
            for (TPProjectModel *model in pArr) {
                if ([model.region.regionId isEqualToString:rId]) {
                    TPProjectListItem *item = [TPProjectListItem new];
                    item.text = model.name;
                    item.pId = model.pId;
                    if ([fArr containsObject:model.pId]) {
                        item.isFavorite = YES;
                    }
                    [arr addObject:item];
                }
            }
        }
        self.items = arr;
        dispatch_async(dispatch_get_main_queue(), ^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                completion(nil);
            });
        });
    });
}
@end

@implementation TPProjectListItem

@end


