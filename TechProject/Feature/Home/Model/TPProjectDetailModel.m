//
//  TPProjectDetailModel.m
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/15.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import "TPProjectDetailModel.h"
#import "TPProjectDataManager.h"
#import "TPCommonDefine.h"
#import <YYCategories.h>
@interface TPProjectInfoItem()

@end

@implementation TPProjectInfoItem

- (void)setInfoString:(NSString *)info{
    NSString *infoStr = [info stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 9;
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:15],
                                 NSParagraphStyleAttributeName:paragraphStyle,
                                 NSForegroundColorAttributeName: [UIColor colorWithHexString:@"525252"]//4a4a4a  454545
                                 };
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:infoStr attributes:attributes];
    _info = str;
    CGSize calculatedSize = [str boundingRectWithSize:CGSizeMake(TPScreenWidth - 45-3, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    self.height = 42 + calculatedSize.height + 11+12 ;
}

@end

@implementation TPProjectInfoNameItem

@end
@implementation TPProjectDetailModel

- (void)loadItems:(NSDictionary *)dict completion:(void (^)(NSDictionary *))completion failure:(void (^)(NSError *))failure{
    NSString *pId = dict[@"pId"];
    NSArray *pArr = [TPProjectDataManager shareInstance].projectArr;
    
    TPProjectModel *model = nil;
    for (TPProjectModel *m in pArr) {
        if ([m.pId isEqualToString:pId]) {
            model = m;
        }
    }
    NSMutableArray *arr = [NSMutableArray array];
    
    TPProjectInfoNameItem *nameItem = [TPProjectInfoNameItem new];
    nameItem.title = model.name;
    nameItem.model = model;
    [arr addObject:nameItem];
    
    NSInteger i = 1;
    for (NSDictionary *dic in model.infoArr) {
        for (NSString *key in dic) {
            TPProjectInfoItem *item = [TPProjectInfoItem new];
            item.title = key;
            item.title = [NSString stringWithFormat:@"%@：", item.title];
            i++;
            [item setInfoString:dic[key]];
            item.model = model;
            [arr addObject:item];
        }
    }
    self.items = arr;
    completion(nil);
}

@end
