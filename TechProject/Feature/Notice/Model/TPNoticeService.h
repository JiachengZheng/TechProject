//
//  TPNoticeService.h
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/9.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TPNoticeService : NSObject

- (void)fetchCategory:(NSDictionary *)params success:(void(^)(NSDictionary *dict))success failure:(void(^)(NSError *error))failure;

- (void)fetchNoticeList:(NSDictionary *)params success:(void(^)(NSDictionary *dict))success failure:(void(^)(NSError *error))failure;

@end
