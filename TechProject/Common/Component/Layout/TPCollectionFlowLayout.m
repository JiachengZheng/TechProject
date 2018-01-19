//
//  TPCollectionFlowLayout.m
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/10.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import "TPCollectionFlowLayout.h"

@implementation TPCollectionFlowLayout
- (instancetype)init{
    if (self = [super init]) {
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    // 垂直滚动
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.minimumInteritemSpacing = 20;

    // 设置collectionView里面内容的内边距（上、左、下、右）
    CGFloat inset = 14;
    self.sectionInset = UIEdgeInsetsMake(inset, inset, inset, inset);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    // 拿到系统已经帮我们计算好的布局属性数组，然后对其进行拷贝一份，后续用这个新拷贝的数组去操作
    NSArray * originalArray   = [super layoutAttributesForElementsInRect:rect];
    NSArray * curArray = [[NSArray alloc] initWithArray:originalArray copyItems:YES];
    
    // 计算collectionView中心点的y值(这个中心点可不是屏幕的中线点哦，是整个collectionView的，所以是包含在屏幕之外的偏移量的哦)
    CGFloat centerY = self.collectionView.contentOffset.y + self.collectionView.frame.size.height * 0.5;
    
    // 拿到每一个cell的布局属性，在原有布局属性的基础上，进行调整
    for (UICollectionViewLayoutAttributes *attrs in curArray) {
        // cell的中心点y 和 collectionView最中心点的y值 的间距的绝对值
        CGFloat space = ABS(attrs.center.y - centerY);
        
        // 根据间距值 计算 cell的缩放比例
        // 间距越大，cell离屏幕中心点越远，那么缩放的scale值就小
        CGFloat scale = 1 - space / self.collectionView.frame.size.height+0.08;
        if (scale <= 1) {
            scale = 1;
        }
        if (self.collectionView.isDragging) {
            attrs.transform = CGAffineTransformMakeScale(scale, scale);
        }
    }
    
    return curArray;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    // 计算出停止滚动时(不是松手时)最终显示的矩形框
    CGRect rect;
    rect.origin.y = proposedContentOffset.y;
    rect.origin.x = 0;
    rect.size = self.collectionView.frame.size;
    
    // 获得系统已经帮我们计算好的布局属性数组
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    // 计算collectionView最中心点的y值
    // 再啰嗦一下，这个proposedContentOffset是系统帮我们已经计算好的，当我们松手后它惯性完全停止后的偏移量
    CGFloat centerY = proposedContentOffset.y + self.collectionView.frame.size.height * 0.5;
    
    // 当完全停止滚动后，离中点Y值最近的那个cell会通过我们多给出的偏移量回到屏幕最中间
    // 存放最小的间距值
    // 先将间距赋值为最大值，这样可以保证第一次一定可以进入这个if条件，这样可以保证一定能闹到最小间距
    CGFloat minSpace = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attrs in array) {
        if (ABS(minSpace) > ABS(attrs.center.y - centerY)) {
            minSpace = attrs.center.y - centerY;
        }
    }
    if (self.collectionView.contentOffset.y <= 0 || self.collectionView.contentOffset.y + self.collectionView.frame.size.height >= self.collectionView.contentSize.height) {
        return proposedContentOffset;
    }
    // 修改原有的偏移量
    proposedContentOffset.y += minSpace;
    NSLog(@"====== %f",proposedContentOffset.y);
    return proposedContentOffset;
}
@end
