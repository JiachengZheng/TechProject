//
//  TPCommonDefine.h
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/8.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#ifndef TPCommonDefine_h
#define TPCommonDefine_h


#endif /* TPCommonDefine_h */

#pragma mark - Common

#define TPEmptyString(str) (!str || ![str isKindOfClass:[NSString class]] || str.length == 0 || [str isEqualToString:@"null"])

#pragma mark - UI
// UIScreen width.
#define  TPScreenWidth   [UIScreen mainScreen].bounds.size.width
// UIScreen height.
#define  TPScreenHeight  [UIScreen mainScreen].bounds.size.height
// iPhone X
#define  TPiPhoneX ((fabs(TPScreenWidth-375.f)<=CGFLOAT_MIN) && (fabs(TPScreenHeight-812.f)<=CGFLOAT_MIN) ? YES : NO)
//Equal or bigger than 9:16
#define TPEqualOrBiggerThan_9_16 (TPScreenHeight >= TP_CANVAS_HEIGHT_9_16)

// Status bar height.
#define  TPStatusBarHeight      (TPiPhoneX ? 44.f : 20.f)
// Navigation bar height.
#define  TPNavigationBarHeight  44.f
// Tabbar height.
#define  TPTabbarHeight         (TPiPhoneX ? (49.f+34.f) : 49.f)
// Tabbar safe bottom margin.
#define  TPTabbarSafeBottomMargin         (TPiPhoneX ? 34.f : 0.f)
// Status bar & navigation bar height.
#define  TPStatusBarAndNavigationBarHeight  (TPiPhoneX ? 88.f : 64.f)
// Safe area
#define TPViewSafeAreaInsets(view) ({UIEdgeInsets insets; if(@available(iOS 11.0, *)) {insets = view.safeAreaInsets;} else {insets = UIEdgeInsetsZero;} insets;})
// RGB
#define TPRGB(r, g, b) [UIColor colorWithRed:(r) / 255.0f green:(g) / 255.0f blue:(b) / 255.0f alpha:1.0f]
// RGBA
#define TPRGBA(r, g, b, a) [UIColor colorWithRed:(r) / 255.0f green:(g) / 255.0f blue:(b) / 255.0f alpha:(a)]
// canvas height
#define TP_CANVAS_HEIGHT_9_16 667.f
// canvas width
#define TP_CANVAS_WIDTH_9_16  375.f
// width ratio
#define W_VALUE_IN_RATIO(VALUE) \
(CGFloat)((VALUE) * ((TPScreenWidth - TP_CANVAS_WIDTH_9_16 < -CGFLOAT_MIN) ? (TPScreenWidth / TP_CANVAS_WIDTH_9_16): 1.f))
// height ratio
#define H_VALUE_IN_RATIO(VALUE) \
(CGFloat)((VALUE) * ((TPScreenHeight - TP_CANVAS_HEIGHT_9_16 < -CGFLOAT_MIN)?(TPScreenHeight / TP_CANVAS_HEIGHT_9_16): 1.f))
// font ratio
#define F_VALUE_IN_RATIO(VALUE) \
(CGFloat)((VALUE) * ((TPScreenHeight - TP_CANVAS_HEIGHT_9_16 < -CGFLOAT_MIN) ? .85f: 1.f))

/* TPCommonDefine_h */
