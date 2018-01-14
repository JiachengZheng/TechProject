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
NSString *const kTPDidReadExcelContentNotification = @"TPDidReadExcelContentNotification";
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
        [self showAlert];
        return nil;
    }
    NSString *name = path.lastPathComponent;
    if ([name isEqualToString:@"test.xls"]) {
        return [self readProjectsContent:reader];
    }
    return nil;
}

- (NSArray *)readProjectsContent:(DHxlsReader *)reader{
#if 0
    [reader startIterator:0];
    while(YES) {
        DHcell *cell = [reader nextCell];
        if(cell.type == cellBlank) break;
        text = [text stringByAppendingFormat:@"\n%@\n", [cell dump]];
    }
#else
    NSMutableArray *typeArr = [NSMutableArray array];
    NSMutableArray <TPProjectRegionModel *>*regionArr = [NSMutableArray array];
    NSMutableArray *projectArr = [NSMutableArray array];
    
    NSInteger col = 2;
    while (YES) {
        DHcell *cell = [reader cellInWorkSheetIndex:0 row:2 col:col];
        if(cell.type == cellBlank) break;
        [typeArr addObject:cell.str];
        col++;
    }
    
    //有合并单元格的情况，逻辑是判断两个中间相差如果大于等于100 ，就停止
    NSInteger row = 3;
    NSInteger maxGap = 100;
    NSInteger curGap = 0;
    NSInteger regionId = 1;
    while (YES) {
        DHcell *cell = [reader cellInWorkSheetIndex:0 row:row col:1];
        if (cell.str) {
            TPProjectRegionModel *region = [TPProjectRegionModel new];
            region.name = cell.str;
            region.regionId = @(regionId++).stringValue;
            [regionArr addObject:region];
            curGap = 0;
        }else{
            curGap ++;
            if (curGap >= maxGap) {
                break;
            }
        }
        row++;
    }
    
    row = 3;
    col = 2;
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
            [projectArr addObject:project];
            project.pId = @(projectArr.count).stringValue;
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
#endif
    return @{@"region": regionArr, @"project": projectArr};
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

- (void)showAlert{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"导入的文件格式必须为xls" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

    }];
    [alertController addAction:confirm];
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alertController animated:YES completion:nil];
}
@end
