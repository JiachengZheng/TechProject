//
//  TPExcelManager.h
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/9.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kTPDidReadExcelContentNotification;
extern NSString *const kTPProjectAddFileName;
extern NSString *const kTPClientAddFileName;
extern NSString *const kTPInitialProjectFileName;
extern NSString *const kTPInitialClientFileName;

@interface TPExcelManager : NSObject

+ (instancetype)shareInstance;

- (NSDictionary *)readExcelContent:(NSString *)path;
@end
