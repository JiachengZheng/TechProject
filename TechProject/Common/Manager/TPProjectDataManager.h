//
//  TPProjectDataManager.h
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/10.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPProjectModel.h"
#import "TPProjectRegionModel.h"
#import "TPClientModel.h"

extern NSString *const TPClientDataDidChangeNotification;
extern NSString *const TPFavoriteStatusDidChangeNotification;

@interface TPProjectDataManager : NSObject

@property (nonatomic, copy, readonly)NSArray <TPProjectRegionModel *> *regionArr;
@property (nonatomic, copy, readonly)NSArray <TPProjectModel *> *projectArr;
@property (nonatomic, copy, readonly)NSArray <TPClientModel *> *clientArr;

@property (nonatomic, copy, readonly)NSArray *favoriteClientsId;
@property (nonatomic, copy, readonly)NSArray *favoriteProjectId;

+ (instancetype)shareInstance;

- (void)loadData;

- (void)addProjectFromExcel:(NSString *)path;
- (void)addClientFromExcel:(NSString *)path;

- (void)saveClientData:(TPClientModel *)model;

- (void)addFavoriteProjectId:(NSString *)pId;
- (void)addFavoriteClientId:(NSString *)cId;

- (void)removeFavoriteProjectId:(NSString *)pId;
- (void)removeFavoriteClientId:(NSString *)cId;

- (void)synchronizationFavorite;
@end
