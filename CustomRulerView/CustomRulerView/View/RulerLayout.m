//
//  RulerLayout.m
//  TYFitFore
//
//  Created by apple on 2018/7/5.
//  Copyright © 2018年 tangpeng. All rights reserved.
//

#import "RulerLayout.h"

@implementation RulerLayout

- (instancetype)init {
    
    if (self = [super init]) {
        [self defaultSetup];
    }
    return self;
}

/** 默认设置 */
- (void)defaultSetup {
    self.itemSize = CGSizeMake(280, 400);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (CGSize)collectionViewContentSize {
    //item总数
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    //宽度 水平方向 = item总数 * (item宽度 + space) - space ; 垂直方向 = collectionView的宽度
    CGFloat width = (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) ? count*(self.itemSize.width+self.spacing)-self.spacing : self.collectionView.bounds.size.width;
    //高度 水平方向 = collectionView的宽度 ; 垂直方向 = item总数 * (item宽度 + space) - space
    CGFloat height = (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) ? self.collectionView.bounds.size.height : count*(self.itemSize.height+self.spacing)-self.spacing;
    return CGSizeMake(width, height);
}

/** 设置每个indexPath对应cell的Attribute */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attribute.size = self.itemSize;
    
    //x坐标 水平方向 = item总数 * (item宽度 + space) ; 垂直方向 = (collectionView - item宽度) / 2.0  (居中显示)
    CGFloat x = (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) ?
    (indexPath.item * (self.spacing + self.itemSize.width)) :
    (0.5 * (self.collectionView.bounds.size.width - self.itemSize.width));
    
    //y坐标 水平方向 = (collectionView - item宽度) / 2.0 (居中显示) ; 垂直方向 = item总数 * (item高度 + space)
    CGFloat y = (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) ?
    (0.5 * (self.collectionView.bounds.size.height - self.itemSize.height)) :
    (indexPath.item * (self.spacing + self.itemSize.height));
    
    //cell的实际frame
    attribute.frame = CGRectMake(x, y, attribute.size.width, attribute.size.height);
    
    return attribute;
}

/** 返回指定rect范围中所有cell的Attributes */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *attributes = [self attributesInRect:rect];
    return attributes;
}

/** 调整最终的偏移 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    
    //原本应该在屏幕中的rect
    CGRect oldRect = CGRectMake(proposedContentOffset.x, proposedContentOffset.y, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    NSArray *attributes = [self layoutAttributesForElementsInRect:oldRect];
    
    //原本应该停留在collectionView中点的位置
    //水平方向中点位置 = 原本应该停留的x点 + collectionView一半宽
    //垂直方向中点位置 = 原本应该停留的y点 + collectionView一半高
    CGFloat center = (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) ?
    (proposedContentOffset.x + 0.5*self.collectionView.bounds.size.width) :
    (proposedContentOffset.y + 0.5*self.collectionView.bounds.size.height);
    
    //找到距离collectionView中点位置最近的cell 并且计算他们之间的最小距离(minOffset)
    CGFloat minOffset = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        CGFloat offset = (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) ? (attribute.center.x - center) : (attribute.center.y - center);
        if (ABS(offset) < ABS(minOffset)) {
            minOffset = offset;
        }
    }
    
    //所以最终应该停留的位置 = collectionView中点位置 + 与之距离最近cell的距离(minOffset) = 实际停留的cell位置
    CGFloat newX = (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) ? (proposedContentOffset.x + minOffset) : proposedContentOffset.x;
    CGFloat newY = (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) ? proposedContentOffset.y : (proposedContentOffset.y + minOffset);
    
    return CGPointMake(newX, newY);
}

/** 返回指定范围内的attributes数组 */
- (NSArray *)attributesInRect:(CGRect)rect {
    //指定范围内的第一个cell的下标
    NSInteger preIndex = (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) ?
    ((rect.origin.x)/(self.itemSize.width+self.spacing)) :
    ((rect.origin.y)/(self.itemSize.height+self.spacing));
    preIndex = ((preIndex < 0) ? 0 : preIndex);                         //防止下标越界
    
    //指定范围内的最后一个cell下标
    NSInteger latIndex = (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) ?
    ((CGRectGetMaxX(rect))/(self.itemSize.width+self.spacing)) :
    ((CGRectGetMaxY(rect))/(self.itemSize.height+self.spacing));
    
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    latIndex = ((latIndex >= itemCount) ? itemCount-1 : latIndex);      //防止下标越界
    
    NSMutableArray *rectAttributes = [NSMutableArray array];
    //将对应下标的attribute存入数组中
    for (NSInteger i=preIndex; i<=latIndex; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForItemAtIndexPath:indexPath];
        if (CGRectIntersectsRect(rect, attribute.frame)) {
            [rectAttributes addObject:attribute];
        }
    }
    return rectAttributes;
}

- (void)setSpacing:(CGFloat)spacing {
    if (_spacing != spacing) {
        _spacing = spacing;
        [self invalidateLayout];
    }
}

- (void)setItemSize:(CGSize)itemSize {
    if (!CGSizeEqualToSize(_itemSize, itemSize)) {
        _itemSize = itemSize;
        [self invalidateLayout];
    }
}

- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection {
    if (_scrollDirection != scrollDirection) {
        _scrollDirection = scrollDirection;
        [self invalidateLayout];
    }
}

@end
