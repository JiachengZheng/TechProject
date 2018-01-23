//
//  TPClientDetailModel.m
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/22.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import "TPClientDetailModel.h"
#import "TPClientModel.h"
@implementation TPClientInfoNameItem
@end

@implementation TPClientInfoItem
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
@implementation TPClientDetailModel
- (void)loadItems:(NSDictionary *)dict completion:(void (^)(NSDictionary *))completion failure:(void (^)(NSError *))failure{

    TPClientModel *model = dict[@"client"];

    NSMutableArray *arr = [NSMutableArray array];
    
    TPClientInfoNameItem *nameItem = [TPClientInfoNameItem new];
    nameItem.title = model.clientName;
    nameItem.model = model;
    
    [arr addObject:nameItem];
    
    NSInteger i = 1;
    for (NSDictionary *info in model.infoArr) {
        for (NSString *key in info) {
            TPClientInfoItem *item = [TPClientInfoItem new];
            item.title = key;
            item.title = [NSString stringWithFormat:@"%@：", item.title];
            i++;
            [item setInfoString:info[key]];
            item.model = model;
            [arr addObject:item];
        }
    }
   
    self.items = arr;
    completion(nil);
}
@end
