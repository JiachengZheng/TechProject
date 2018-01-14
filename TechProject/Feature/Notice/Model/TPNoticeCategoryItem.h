//
//  TPNoticeCategoryItem.h
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/9.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TPNoticeCategoryItem : NSObject
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *cId;

+ (NSArray *)wrapperData:(NSArray *)arr;
@end
