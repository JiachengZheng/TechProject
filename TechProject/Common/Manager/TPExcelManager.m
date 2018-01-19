//
//  TPExcelManager.m
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/9.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import "TPExcelManager.h"
#import "DHxlsReaderIOS.h"
#import "TPProjectModel.h"
#import "TPCommonDefine.h"
#import "TPUtil.h"
#import "TPProjectDataManager.h"
NSString *const kTPDidReadExcelContentNotification = @"TPDidReadExcelContentNotification";
NSString *const kTPProjectAddFileName = @"add_project";
NSString *const kTPInitialProjectFileName = @"initial_data_project.xls";
@interface TPExcelManager ()

@end

@implementation TPExcelManager

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    static TPExcelManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[TPExcelManager alloc] init];
    });
    return instance;
}

- (NSDictionary *)readExcelContent:(NSString *)path;{
    DHxlsReader *reader = [DHxlsReader xlsReaderFromFile:path];
    if (!reader) {
        [TPUtil showAlert:@"无法该读取文件"];
        return nil;
    }
    NSString *name = [path lastPathComponent];
    if ([name hasPrefix:kTPInitialProjectFileName] || [name hasPrefix:kTPProjectAddFileName]) {
        return [self readProjectsContent:reader];
    }
    [TPUtil showAlert:@"暂时无法处理该文件"];
    return nil;
}

- (NSDictionary *)readProjectsContent:(DHxlsReader *)reader{
    NSMutableArray *rArr = [NSMutableArray arrayWithArray:[TPProjectDataManager shareInstance].regionArr];
    [rArr addObjectsFromArray:[self readRegionInfo:reader]];
    NSArray *projectArr = [self readProjectInfo:reader regionArr:rArr];
    return @{@"region": rArr, @"project": projectArr};
}

- (NSArray *)readTypeInfo:(DHxlsReader *)reader{
    //读取项目子标题
    NSMutableArray *typeArr = [NSMutableArray array];
    NSInteger col = 2;
    while (YES) {
        DHcell *cell = [reader cellInWorkSheetIndex:0 row:2 col:col];
        if(cell.type == cellBlank) break;
        [typeArr addObject:cell.str];
        col++;
    }
    return typeArr;
}

//读取地区信息
- (NSArray *)readRegionInfo:(DHxlsReader *)reader{
    NSMutableArray <TPProjectRegionModel *>*regionArr = [NSMutableArray array];
    NSInteger maxGap = 100;//有合并单元格的情况，判断两个中间相差如果大于等于100 ，就停止
    NSInteger row = 3; //从第三行开始读取
    NSInteger curGap = 0;
    while (YES) {
        DHcell *cell = [reader cellInWorkSheetIndex:0 row:row col:1];
        if (cell.str) {
            TPProjectRegionModel *oldRegion = [self alreadyContainRegionInfo:cell.str];
            if (!oldRegion) {
                TPProjectRegionModel *region = [TPProjectRegionModel new];
                region.name = cell.str;
                region.regionId = [TPUtil generateUUID];
                [regionArr addObject:region];
            }
            curGap = 0;
        }else{
            curGap ++;
            if (curGap >= maxGap) {
                break;
            }
        }
        row++;
    }
    return regionArr;
}

- (TPProjectRegionModel *)alreadyContainRegionInfo:(NSString *)name{
    NSArray *rArr = [TPProjectDataManager shareInstance].regionArr;
    for (TPProjectRegionModel *model in rArr) {
        if ([model.name isEqualToString:name]) {
            return model;
        }
    }
    return nil;
}

- (BOOL)alreadyContainProject:(NSString *)name{
    NSArray *pArr = [TPProjectDataManager shareInstance].projectArr;
    for (TPProjectModel *model in pArr) {
        if ([model.name isEqualToString:name]) {
            return YES;
        }
    }
    return NO;
}

- (NSArray *)readProjectInfo:(DHxlsReader *)reader regionArr:(NSArray *)regionArr{
    NSArray *typeArr = [self readTypeInfo:reader];
    
    //读取项目信息
    NSMutableArray *projectArr = [NSMutableArray array];
    NSInteger row = 3;
    NSInteger col = 2;
    NSInteger typeIndex = 0;
    TPProjectRegionModel *curRegion = regionArr[0];
    NSString *curKey = typeArr[typeIndex];
    
    TPProjectModel *project = [TPProjectModel new];
    while (YES) {
        DHcell *cell = [reader cellInWorkSheetIndex:0 row:row col:col];
        DHcell *regionCell = [reader cellInWorkSheetIndex:0 row:row col:1];
        
        if (regionCell.str) {
            for (TPProjectRegionModel *r in regionArr) {
                if ([r.name isEqualToString:regionCell.str]) {
                    curRegion = r;
                    break;
                }
            }
        }
        project.region = curRegion;
        NSString*value = cell.str;
        if (!TPEmptyString(value) && !TPEmptyString(curKey)) {
            if (col == 2) {
                project.name = value;
            }else{
                [project.infoArr addObject:@{curKey:value}];
            }
        }
        if (col == 2 && TPEmptyString(value)) {
            break;
        }
        
        if(cell.type == cellBlank || typeIndex == typeArr.count-1){
            if (![self alreadyContainProject:project.name]) {
                [projectArr addObject:project];
            }
            project.pId = [TPUtil generateUUID];
            project = [TPProjectModel new];
            row ++;
            typeIndex = 0;
            col = 2;
        }else{
            col++;
            typeIndex++;
            if (typeArr.count == typeIndex) {
                curKey = nil;
            }
            curKey = typeArr[typeIndex];
        }
    }
    return projectArr;
}













- (NSString *)excelDescription:(NSString *)path{
    DHxlsReader *reader = [DHxlsReader xlsReaderFromFile:path];
    if (!reader) {
        return nil;
    }
    NSString *text = @"";
    text = [text stringByAppendingFormat:@"AppName: %@\n", reader.appName];
    text = [text stringByAppendingFormat:@"Author: %@\n", reader.author];
    text = [text stringByAppendingFormat:@"Category: %@\n", reader.category];
    text = [text stringByAppendingFormat:@"Comment: %@\n", reader.comment];
    text = [text stringByAppendingFormat:@"Company: %@\n", reader.company];
    text = [text stringByAppendingFormat:@"Keywords: %@\n", reader.keywords];
    text = [text stringByAppendingFormat:@"LastAuthor: %@\n", reader.lastAuthor];
    text = [text stringByAppendingFormat:@"Manager: %@\n", reader.manager];
    text = [text stringByAppendingFormat:@"Subject: %@\n", reader.subject];
    text = [text stringByAppendingFormat:@"Title: %@\n", reader.title];
    text = [text stringByAppendingFormat:@"\n\nNumber of Sheets: %lu\n", (unsigned long)reader.numberOfSheets];
    return text;
}


@end
