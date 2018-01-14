//
//  TPNoticeService.m
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/9.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import "TPNoticeService.h"
#import <AFNetworking.h>

#define kHost  @"http://39.106.199.118"
@implementation TPNoticeService
- (void)fetchCategory:(NSDictionary *)params success:(void(^)(NSDictionary *dict))success failure:(void(^)(NSError *error))failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = [NSString stringWithFormat:@"%@%@",kHost,@"/article/categorys"];
    [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        NSLog(@"failure--%@",error);
    }];
}

- (void)fetchNoticeList:(NSDictionary *)params success:(void(^)(NSDictionary *dict))success failure:(void(^)(NSError *error))failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = [NSString stringWithFormat:@"%@%@",kHost,@"/article/list_by_category"];
    [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        NSLog(@"failure--%@",error);
    }];
}
@end
