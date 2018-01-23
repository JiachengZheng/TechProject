//
//  TPFavoriteModel.m
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/23.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import "TPFavoriteModel.h"
#import "TPBarItem.h"
@implementation TPFavoriteModel

- (void)loadItems:(NSDictionary *)dict completion:(void (^)(NSDictionary *))completion failure:(void (^)(NSError *))failure{
    
    NSMutableArray *mutableArr = [NSMutableArray array];
    TPBarItem *pItem = [TPBarItem new];
    pItem.text = @"项目";
    pItem.index = 0;
    pItem.width = TPScreenWidth/2;
    pItem.identifier = @"project";
    [mutableArr addObject:pItem];
    
    TPBarItem *cItem = [TPBarItem new];
    cItem.text = @"客户";
    cItem.index = 1;
    cItem.width = TPScreenWidth/2;
    cItem.identifier = @"client";
    [mutableArr addObject:cItem];
    
    self.items = mutableArr;
    completion(nil);
}

// text size
- (CGSize)boundingSizeWithString:(NSString *)string font:(UIFont *)font constrainedToSize:(CGSize)size{
    CGSize textSize = CGSizeZero;
    
#if (__IPHONE_OS_VERSION_MIN_REQUIRED && __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0)
    
    if (![string respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        // below ios7
        textSize = [string sizeWithFont:font
                      constrainedToSize:size
                          lineBreakMode:NSLineBreakByWordWrapping];
    }
    else
#endif
    {
        //iOS 7
        CGRect frame = [string boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{ NSFontAttributeName:font } context:nil];
        textSize = CGSizeMake(frame.size.width, frame.size.height + 1);
    }
    
    return textSize;
}
@end
