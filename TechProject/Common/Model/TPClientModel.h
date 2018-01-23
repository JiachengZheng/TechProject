//
//  TPClientModel.h
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/22.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TPClientModel : NSObject
@property (nonatomic, copy) NSString *projectName;
@property (nonatomic, copy) NSString *clientName;
@property (nonatomic, copy) NSString *clientId;
@property (nonatomic, copy) NSString *projectNumber;
@property (nonatomic, copy) NSString *region;
@property (nonatomic, copy) NSArray *infoArr;
@end
