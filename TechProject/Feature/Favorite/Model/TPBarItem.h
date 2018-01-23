//
//  TPBarItem.h
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/23.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface TPBarItem : NSObject
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) NSInteger index;
@end
