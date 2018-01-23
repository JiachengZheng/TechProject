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
#import "TPProjectRegionModel.h"
#import "TPClientModel.h"
NSString *const TPClientDataDidChangeNotification = @"TPClientDataDidChangeNotification";
NSString *const TPFavoriteStatusDidChangeNotification = @"TPFavoriteStatusDidChangeNotification";

NSString *const kTPProjectStoreKey = @"TPProjectStoreKey";
NSString *const kTPProjectRegionStoreKey = @"TPProjectRegionStoreKey";
NSString *const kTPProjectClientStoreKey = @"TPProjectClientStoreKey";
NSString *const kTPProjectFavoriteKey = @"kTPProjectFavoriteKey";
NSString *const kTPClientFavoriteKey = @"kTPClientFavoriteKey";

@interface TPProjectDataManager()
@property (nonatomic, strong) dispatch_queue_t queue;
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
        self.queue = dispatch_queue_create("com.zhengjiacheng.data", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)loadDB{
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"myDB.sqlite"];
#ifdef DEBUG
    [MagicalRecord setLoggingLevel:MagicalRecordLoggingLevelWarn];
#endif
}

- (void)fetchFavoriteData{
    NSArray *resultArr = [TPStoreModel MR_findByAttribute:@"key" withValue:kTPClientFavoriteKey];
    if (resultArr.count > 0) {
        TPStoreModel *model = resultArr.firstObject;
        NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:model.value];
        _favoriteClientsId = arr;
    }
    NSArray *resultArr1 = [TPStoreModel MR_findByAttribute:@"key" withValue:kTPProjectFavoriteKey];
    if (resultArr1.count > 0) {
        TPStoreModel *model = resultArr1.firstObject;
        NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:model.value];
        _favoriteProjectId = arr;
    }
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

- (NSArray <TPClientModel *> *)fetchClientDataFromDB{
    NSArray *resultArr = [TPStoreModel MR_findByAttribute:@"key" withValue:kTPProjectClientStoreKey];
    if (resultArr.count > 0) {
        TPStoreModel *model = resultArr.firstObject;
        NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:model.value];
        return arr;
    }
    return nil;
}

- (void)addClientFromExcel:(NSString *)path{
    NSDictionary *dict = [[TPExcelManager shareInstance]readExcelContent:path];
    NSArray *clientArr = [dict valueForKey:@"client"] ?: @[];
    
    [TPUtil cleanInboxFiles];
    
    if (clientArr.count < 1) {
        [TPUtil showAlert:@"没有新增客户"];
        return;
    }
    
    _clientArr = [clientArr copy];
    
    [self saveClientArr:_clientArr];
    [[NSNotificationCenter defaultCenter]postNotificationName:TPClientDataDidChangeNotification object:nil];
    [TPUtil showAlert:[NSString stringWithFormat:@"成功导入客户数据"]];
}

- (void)addProjectFromExcel:(NSString *)path{
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
    [self fetchFavoriteData];
    
    NSArray *regionArr = [self fetchProjectRegionDataFromDB];
    NSArray *pArr = [self fetchProjectDataFromDB];
    NSArray *cArr = [self fetchClientDataFromDB];
    
    if (!pArr || pArr.count == 0) {
        [self loadLocalProjectFile];
    }else{
        _projectArr = pArr;
        _regionArr = regionArr;
    }
    
    if (!cArr || cArr.count == 0) {
        [self loadLocalClientFile];
    }else{
        _clientArr = cArr;
    }
     [self save];
}

- (void)loadLocalProjectFile{
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kTPInitialProjectFileName];
    NSDictionary *dict = [[TPExcelManager shareInstance]readExcelContent:path];
    NSArray *regionArr = [dict valueForKey:@"region"] ?: @[];
    NSArray *projectArr = [dict valueForKey:@"project"]?: @[];
    
    _regionArr = regionArr;
    _projectArr = projectArr;
}

- (void)loadLocalClientFile{
    NSString *clientPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kTPInitialClientFileName];
    NSDictionary *clientDict = [[TPExcelManager shareInstance]readExcelContent:clientPath];
    NSArray *clientArr = [clientDict valueForKey:@"client"] ?: @[];
    
    _clientArr = clientArr;
}

- (void)save{
    [self saveProjectArr:_projectArr];
    [self saveProjectRegionArr:_regionArr];
    [self saveClientArr:_clientArr];
}

- (void)saveClientData:(TPClientModel *)client{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:_clientArr];
    NSInteger i = 0;
    for (TPClientModel *model in _clientArr) {
        if ([model.clientName isEqualToString:client.clientName]) {
            [arr replaceObjectAtIndex:i withObject:client];
            break;
        }
        i++;
    }
    _clientArr = [arr copy];
    [self saveClientArr:_clientArr];
    [[NSNotificationCenter defaultCenter]postNotificationName:TPClientDataDidChangeNotification object:nil];
}

- (void)saveClientArr:(NSArray *)clientArr{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        NSArray *models = [TPStoreModel MR_findByAttribute:@"key" withValue:kTPProjectClientStoreKey inContext:localContext];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:clientArr];
        TPStoreModel *model = models.firstObject;
        if (!model) {
            model = [TPStoreModel MR_createEntityInContext:localContext];
        }
        model.date = [NSDate date];
        model.value = data;
        model.key = kTPProjectClientStoreKey;
    } completion:^(BOOL contextDidSave, NSError *error) {
        
    }];
}

- (void)saveProjectArr:(NSArray *)projectArr {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        NSArray *models = [TPStoreModel MR_findByAttribute:@"key" withValue:kTPProjectStoreKey inContext:localContext];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:projectArr];
        TPStoreModel *model = models.firstObject;
        if (!model) {
            model = [TPStoreModel MR_createEntityInContext:localContext];
        }
        model.date = [NSDate date];
        model.value = data;
        model.key = kTPProjectStoreKey;
    } completion:^(BOOL contextDidSave, NSError *error) {
    
    }];
}

- (void)saveProjectRegionArr:(NSArray *)rArr {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        NSArray *models = [TPStoreModel MR_findByAttribute:@"key" withValue:kTPProjectRegionStoreKey inContext:localContext];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:rArr];
        TPStoreModel *model = models.firstObject;
        if (!model) {
            model = [TPStoreModel MR_createEntityInContext:localContext];
        }
        model.date = [NSDate date];
        model.value = data;
        model.key = kTPProjectRegionStoreKey;
    } completion:^(BOOL contextDidSave, NSError *error) {
        
    }];
}

- (void)addFavoriteProjectId:(NSString *)pId{
    NSString *projectId = pId;
    if (!projectId) {
        return;
    }
    dispatch_async(self.queue, ^{
        NSMutableArray *arr = [NSMutableArray arrayWithArray:_favoriteProjectId];
        if (![arr containsObject:projectId]) {
            [arr addObject:projectId];
        }
        _favoriteProjectId = [arr copy];
    });
}

- (void)addFavoriteClientId:(NSString *)cId{
    NSString *clientId = cId;
    if (!clientId) {
        return;
    }
    dispatch_async(self.queue, ^{
        NSMutableArray *arr = [NSMutableArray arrayWithArray:_favoriteClientsId];
        if (![arr containsObject:clientId]) {
            [arr addObject:clientId];
        }
        _favoriteClientsId = [arr copy];
    });
}

- (void)removeFavoriteProjectId:(NSString *)pId{
    dispatch_async(self.queue, ^{
        NSMutableArray *arr = [NSMutableArray arrayWithArray:_favoriteProjectId];
        if ([arr containsObject:pId]) {
            [arr removeObject:pId];
        }
        _favoriteProjectId = [arr copy];
    });
}

- (void)removeFavoriteClientId:(NSString *)cId{
    dispatch_async(self.queue, ^{
        NSMutableArray *arr = [NSMutableArray arrayWithArray:_favoriteClientsId];
        if ([arr containsObject:cId]) {
            [arr removeObject:cId];
        }
        _favoriteClientsId = [arr copy];
    });
}

- (void)synchronizationFavorite{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        NSArray *models = [TPStoreModel MR_findByAttribute:@"key" withValue:kTPProjectFavoriteKey inContext:localContext];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_favoriteProjectId];
        TPStoreModel *model = models.firstObject;
        if (!model) {
            model = [TPStoreModel MR_createEntityInContext:localContext];
        }
        model.date = [NSDate date];
        model.value = data;
        model.key = kTPProjectFavoriteKey;
    } completion:^(BOOL contextDidSave, NSError *error) {
        
    }];
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        NSArray *models = [TPStoreModel MR_findByAttribute:@"key" withValue:kTPClientFavoriteKey inContext:localContext];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_favoriteClientsId];
        TPStoreModel *model = models.firstObject;
        if (!model) {
            model = [TPStoreModel MR_createEntityInContext:localContext];
        }
        model.date = [NSDate date];
        model.value = data;
        model.key = kTPClientFavoriteKey;
    } completion:^(BOOL contextDidSave, NSError *error) {
        
    }];
    [[NSNotificationCenter defaultCenter]postNotificationName:TPFavoriteStatusDidChangeNotification object:nil];
}

@end
