//
//  TPProjectDataManager.m
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/10.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import "TPProjectDataManager.h"
#import "TPExcelManager.h"
#import <MagicalRecord/MagicalRecord.h>
#import "TPStoreModel+CoreDataClass.h"
#import "TPStoreModel+CoreDataProperties.h"
#import "TPUtil.h"
NSString *const kTPProjectStoreKey = @"TPProjectStoreKey";
NSString *const kTPProjectRegionStoreKey = @"TPProjectRegionStoreKey";


@interface TPProjectDataManager()

@end

@implementation TPProjectDataManager

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    static TPProjectDataManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[TPProjectDataManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadDB];
    }
    return self;
}

- (void)loadDB{
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"myDB.sqlite"];
#ifdef DEBUG
    [MagicalRecord setLoggingLevel:MagicalRecordLoggingLevelAll];
#endif
}

- (NSArray <TPProjectModel *> *)fetchProjectDataFromDB{
    NSArray *resultArr = [TPStoreModel MR_findByAttribute:@"key" withValue:kTPProjectStoreKey];
    if (resultArr.count > 0) {
        TPStoreModel *model = resultArr.firstObject;
        NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:model.value];
        return arr;
    }
    return nil;
}

- (void)addProjectFromExcel:(NSString *)path;{
    NSDictionary *dict = [[TPExcelManager shareInstance]readExcelContent:path];
    NSArray *regionArr = [dict valueForKey:@"region"] ?: @[];
    NSArray *projectArr = [dict valueForKey:@"project"]?: @[];
    
    [TPUtil cleanInboxFiles];
    
    if (projectArr.count < 1) {
        [TPUtil showAlert:@"项目数据重复，没有新增项目"];
        return;
    }
    
    NSMutableArray *pArr = [NSMutableArray arrayWithArray:self.projectArr];
    [pArr addObjectsFromArray:projectArr];
    _projectArr = [pArr copy];
    
    _regionArr = [regionArr copy];
    
    [self save];
    [[NSNotificationCenter defaultCenter]postNotificationName:kTPDidReadExcelContentNotification object:nil];
    [TPUtil showAlert:[NSString stringWithFormat:@"成功导入%ld条项目数据",projectArr.count]];
}

- (NSArray <TPProjectRegionModel *> *)fetchProjectRegionDataFromDB{
    NSArray *resultArr = [TPStoreModel MR_findByAttribute:@"key" withValue:kTPProjectRegionStoreKey];
    if (resultArr.count > 0) {
        TPStoreModel *model = resultArr.firstObject;
        NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:model.value];
        return arr;
    }
    return nil;
}

- (void)loadData{
    NSArray *regionArr = [self fetchProjectRegionDataFromDB];
    NSArray *pArr = [self fetchProjectDataFromDB];
    
    if (!pArr || pArr.count == 0) {
        [self loadLocalFile];
    }else{
        _projectArr = pArr;
        _regionArr = regionArr;
    }
}

- (void)loadLocalFile{
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kTPInitialProjectFileName];
    NSDictionary *dict = [[TPExcelManager shareInstance]readExcelContent:path];
    NSArray *regionArr = [dict valueForKey:@"region"] ?: @[];
    NSArray *projectArr = [dict valueForKey:@"project"]?: @[];
    
    _regionArr = regionArr;
    _projectArr = projectArr;

    [self save];
}

- (void)save{
    [self saveProjectArr:_projectArr];
    [self saveProjectRegionArr:_regionArr];
}

- (void)saveProjectArr:(NSArray *)projectArr {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        TPStoreModel *model = [TPStoreModel MR_findFirstByAttribute:@"key" withValue:kTPProjectStoreKey inContext:localContext];
        if (!model) {
            model = [TPStoreModel MR_createEntityInContext:localContext];
        }
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:projectArr];
        model.date = [NSDate date];
        model.value = data;
        model.key = kTPProjectStoreKey;
    } completion:^(BOOL contextDidSave, NSError *error) {
    
    }];
}

- (void)saveProjectRegionArr:(NSArray *)rArr {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        TPStoreModel *model = [TPStoreModel MR_findFirstByAttribute:@"key" withValue:kTPProjectRegionStoreKey inContext:localContext];
        if (!model) {
            model = [TPStoreModel MR_createEntityInContext:localContext];
        }
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:rArr];
        model.date = [NSDate date];
        model.value = data;
        model.key = kTPProjectRegionStoreKey;
    } completion:^(BOOL contextDidSave, NSError *error) {
        
    }];
}


@end
