//
//  TPRefreshHeaderView.h
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/9.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, TPRefreshHeaderState) {
    TPRefreshHeaderStateNone,
    TPRefreshHeaderStatePulling,
    TPRefreshHeaderStateRefreshing,
};
@interface TPRefreshHeaderView : UIView

@property (nonatomic, copy) void(^handle)(void);
@property (nonatomic, assign) TPRefreshHeaderState status;
- (void)endRefreshing;
@end
