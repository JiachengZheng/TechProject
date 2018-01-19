//
//  TPSnowView.m
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/18.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import "TPSnowView.h"
@interface TPSnowView()
@property (nonatomic, strong) CAEmitterCell *cell;
@property (nonatomic, strong) CAEmitterLayer *emitter;
@end

@implementation TPSnowView

+ (void)show{
    TPSnowView *view = [TPSnowView new];
    [view showSnowInView:[UIApplication sharedApplication].delegate.window];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [view hiddenSnow];
        [view removeFromSuperview];
    });
}

- (void)showSnowInView:(UIView *)view{
    if (!_cell) {
        // 通过CAEmitterLayer可以很原生的创造微粒效果,不需要第三方库
        CAEmitterLayer *emitter = [CAEmitterLayer new];
        self.emitter = emitter;
        emitter.backgroundColor = [UIColor clearColor].CGColor;
        CGRect rect = CGRectMake(0, -100, view.bounds.size.width, view.bounds.size.height + 100);
        emitter.frame = rect;
        [view.layer addSublayer:emitter];
        
        // kCAEmitterLayerPoint 将所有的粒子集中在position的位置,可用来做火花爆炸效果
        // kCAEmitterLayerLine 所有的粒子位于一条线上,可用来作瀑布效果
        // kCAEmitterLayerRectangle 所有粒子随机出现在所给定的矩形框内
        emitter.emitterShape = kCAEmitterLayerLine;
        emitter.emitterPosition = CGPointMake(emitter.frame.size.width/2, 0);
        emitter.emitterSize = rect.size;
        
        // 一个cell代表一个微粒
        CAEmitterCell * emitterCell = [CAEmitterCell emitterCell];
        emitterCell.contents = (__bridge id _Nullable)([UIImage imageNamed:@"snow2"].CGImage);
        self.cell = emitterCell;
        // 每秒创建的cell
        // cell的生命周期为1.5秒
        emitterCell.lifetime = 10;
        // emitter可以添加很多不同类型的cell
        emitter.emitterCells = @[emitterCell];
        
        // 制造一个y轴的加速度
        emitterCell.yAcceleration = 25.0;
        // 制造一个x轴的加速度
        emitterCell.xAcceleration = 2.0;
        
        //        emitterCell.velocity = 20.0
        // 给微粒设置一个发射角度
        emitterCell.emissionLongitude = -M_PI;
        //        emitterCell.scale = 0.8
        
        // 添加随机的速度,如果有velocity,那么范围为 -180 ~ 220
        emitterCell.velocityRange = 100.0;
        emitterCell.emissionRange = M_PI_2;
        
        emitterCell.lifetimeRange = 18;
        
        //        emitterCell.color = UIColor(red: 0.9, green: 1.0, blue: 1.0, alpha: 1.0).CGColor
        // 值为0.3 的范围为 0.7~1.3,但由于高于1算1,所以值得范围为 0.7~1
        emitterCell.redRange = 0.1;
        emitterCell.greenRange = 0.1;
        emitterCell.blueRange = 0.1;
        // 随机大小
        emitterCell.scaleRange = 0.8;
        // 每秒缩小15%
        emitterCell.scaleSpeed = -0.05;
        
        emitterCell.alphaRange = 0.75;;
        emitterCell.alphaSpeed = -0.15;
    }
    _cell.birthRate = 35;
}

- (void)hiddenSnow{
    _emitter.birthRate = 0;
}

- (void)dealloc
{
    
}


@end
