//
//  TPNoticeListItem.h
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/9.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TPNoticeListItem : NSObject
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) NSNumber *aId;
@property (nonatomic, strong) NSNumber *categoryId;

+ (NSArray *)wrapperData:(NSArray *)arr;
@end
