//
//  TPClientDetailModel.h
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/22.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import "TPBaseModel.h"
#import "TPClientModel.h"
@interface TPClientInfoNameItem: NSObject
@property (nonatomic, strong) TPClientModel *model;
@property (nonatomic, copy)NSString *title;

@end

@interface TPClientInfoItem: NSObject
@property (nonatomic, strong) TPClientModel *model;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, strong)NSAttributedString *info;
@property (nonatomic, assign) CGFloat height;

- (void)setInfoString:(NSString *)info;
@end
@interface TPClientDetailModel : TPBaseModel

@end
