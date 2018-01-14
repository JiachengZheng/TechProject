//
//  TPNoticeModel.m
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/8.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import "TPNoticeModel.h"
#import "TPNoticeCategoryItem.h"
#import "TPNoticeService.h"

@interface TPNoticeModel()
@property (nonatomic, strong) TPNoticeService *service;
@end

@implementation TPNoticeModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.service = [TPNoticeService new];
    }
    return self;
}

- (void)loadItems:(NSDictionary *)dict completion:(void(^)(NSDictionary *))completion failure:(void(^)(NSError *))failure{
    __weak typeof(self) instance = self;
    [self.service fetchCategory:dict success:^(NSDictionary *dict) {
        instance.items = [TPNoticeCategoryItem wrapperData:(NSArray *)dict];
        completion(nil);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
@end
