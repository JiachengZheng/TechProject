//
//  TPClientInfoEditVCL.h
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/22.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import "TPBaseViewController.h"
#import "TPClientModel.h"
@interface TPClientInfoEditVCL : TPBaseViewController
@property (nonatomic, strong) TPClientModel *client;
@property (nonatomic, copy) NSString *editType;
@property (nonatomic, copy) NSString *editValue;
@end
