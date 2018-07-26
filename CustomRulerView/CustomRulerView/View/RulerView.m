//
//  RulerView.m
//  TYFitFore
//
//  Created by apple on 2018/7/5.
//  Copyright © 2018年 tangpeng. All rights reserved.
//

#import "RulerView.h"

#import "RulerLayout.h"

#define kDirectionHorizontal (self.rulerLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal)

static NSString *const rulerCollectionViewCellIdentifier = @"rulerCollectionViewCellIdentifier";

@interface RulerView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) RulerLayout *rulerLayout;
@property (nonatomic, strong) UICollectionView *rulerCollectionView;                        /**< 刻度尺实际实现视图  */
@property (nonatomic, strong) UIImageView *indicatorView;                                   /**< 指示器视图  */
//layer层，渐变layer
@property (nonatomic, strong) CAGradientLayer *startGradientLayer;
@property (nonatomic, strong) CAGradientLayer *endGradientLayer;

@property (nonatomic, assign) NSInteger selectIndex;                                        /**< 当前选中的下标  */
@property (nonatomic, assign) BOOL activeDelegate;                                          /**< 允许调用代理方法  */

@end

@implementation RulerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self defaultSettings];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    //视图布局
    [self layoutViews];
}

#pragma mark - 默认设置
- (void)defaultSettings {
    //刻度高度
    self.shortScaleLength = 17.5;
    self.longScaleLength = 25;
    //刻度宽度
    self.scaleWidth = 2;
    //刻度起始位置
    self.shortScaleStart = 25;
    self.longScaleStart = 25;
    //刻度颜色
    self.scaleColor = UIColorFromHex(0xdae0ed);
    //刻度之间的距离
    self.distanceBetweenScale = 8;
    //刻度距离数字的距离
    self.distanceFromScaleToNumber = 35;
    //指示视图属性设置
    self.pointSize = CGSizeMake(4, 40);
    self.pointColor = UIColorFromHex(0x20c6ba);
    self.pointStart = 20;
    //文字属性
    self.numberFont = [UIFont systemFontOfSize:11];
    self.numberColor = UIColorFromHex(0x617272);
    self.numberDirection = numberBottom;
    self.min = 0;
}

#pragma mark - 视图布局
- (void)layoutViews {
    
    //添加渐变层
    if (self.useGradient) {
        [self addStartGradientLayer];
        [self addEndGradientLayer];
    }
    
    //计算cell的size
    self.rulerLayout = [[RulerLayout alloc] init];
    self.rulerLayout.spacing = self.distanceBetweenScale;
    if (self.numberDirection == numberTop || self.numberDirection == numberBottom) {
        //水平方向
        self.rulerLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.rulerLayout.itemSize = CGSizeMake(self.scaleWidth, CGRectGetHeight(self.frame));
    } else {
        //垂直方向
        self.rulerLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.rulerLayout.itemSize = CGSizeMake(CGRectGetWidth(self.frame), self.scaleWidth);
    }
    
    self.rulerCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.rulerLayout];
    self.rulerCollectionView.delegate = self;
    self.rulerCollectionView.dataSource = self;
    self.rulerCollectionView.showsVerticalScrollIndicator = NO;
    self.rulerCollectionView.showsHorizontalScrollIndicator = NO;
    self.rulerCollectionView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    
    //前后偏移
    self.rulerCollectionView.contentInset = (kDirectionHorizontal ? UIEdgeInsetsMake(0, CGRectGetWidth(self.frame)/2.0, 0, CGRectGetWidth(self.frame)/2.0) : UIEdgeInsetsMake(CGRectGetHeight(self.frame)/2.0, 0, CGRectGetHeight(self.frame)/2.0, 0));
    self.rulerCollectionView.bounces = NO;
    [self.rulerCollectionView registerClass:[RulerCollectionViewCell class] forCellWithReuseIdentifier:rulerCollectionViewCellIdentifier];
    [self addSubview:self.rulerCollectionView];
    
    //指针
    self.indicatorView = [[UIImageView alloc] init];
    [self centerPointView];
    self.indicatorView.backgroundColor = self.pointColor;
    self.indicatorView.layer.cornerRadius = self.pointSize.width/2.0;
    [self addSubview:self.indicatorView];
    
    //默认选中 偏移 = 指定数值 * (cell宽 + 刻度之间的距离) - 默认偏移 + cell宽的一半
    double offset = 0;
    //初始偏移值
    double contentInset = (kDirectionHorizontal ? self.rulerCollectionView.contentInset.left : self.rulerCollectionView.contentInset.top);
    BOOL suitableNumber = NO;           //默认选中值是否符合条件
    
    //默认选中值有效才能调用偏移方法
    double activeSelectionNumber = self.defaultNumber - self.min;
    if (activeSelectionNumber >= 0) {
        if (self.isDecimal) {
            //偏移计算：(单个刻度尺宽度 + 刻度尺间距) * 总刻度 - 起始偏移 + 最后一个刻度宽度 / 2.0
            offset = activeSelectionNumber * 10 * (self.scaleWidth + self.distanceBetweenScale) - contentInset + (self.scaleWidth / 2.0);
            //检测数字是否符合条件
            NSString *defaultValue = [NSString stringWithFormat:@"%lf", activeSelectionNumber * 10];
            if ([RulerView isPureInt:defaultValue]) {
                self.selectIndex = activeSelectionNumber * 10;
                suitableNumber = YES;
            }
        } else {
            //偏移计算：(单个刻度尺宽度 + 刻度尺间距) * 总刻度 - 起始偏移 + 最后一个刻度宽度 / 2.0
            offset = activeSelectionNumber * (self.scaleWidth + self.distanceBetweenScale) - contentInset + (self.scaleWidth / 2.0);
            self.selectIndex = activeSelectionNumber;
            suitableNumber = YES;
        }
    }

    //如果没有默认值，就初始偏移
    if (offset == 0) {
        offset = -(contentInset - self.scaleWidth / 2.0);
    }
    //有效偏移才允许调用代理方法
    if (suitableNumber) {
        self.activeDelegate = YES;
    }
    
    //校正偏差
    [self correctionDeviation:offset];
    self.rulerCollectionView.contentOffset = (kDirectionHorizontal ? CGPointMake(offset, 0) : CGPointMake(0, offset)); //此方法会触发scrollViewDidScroll
    
    //默认选中(符号条件的才能默认选中)
    if (self.selectionEnable && suitableNumber) {
        [self.rulerCollectionView layoutIfNeeded];
        [self selectCell];
    }
    self.activeDelegate = YES;
}

/** 指示视图居中 */
- (void)centerPointView {
    if (kDirectionHorizontal) {
        self.indicatorView.frame = CGRectMake((CGRectGetWidth(self.frame) - self.pointSize.width)/2.0, self.pointStart, self.pointSize.width, self.pointSize.height);
    } else {
        self.indicatorView.frame = CGRectMake(self.pointStart, (CGRectGetHeight(self.frame) - self.pointSize.width)/2.0, self.pointSize.height, self.pointSize.width);
    }
}

/** 校正偏差 */
- (void)correctionDeviation:(double)offset {
    //偏差校正说明：因为计算出来的偏移量会有小数，scrollview在设置偏移量时，会自动将小数偏移四舍五入
    //所以用指示视图的位置来校正这个偏差。当刻度尺开始滑动时，复原指示视图的位置
    NSInteger roundOffset = roundl(offset);
    double deviation = offset - roundOffset;
    if (kDirectionHorizontal) {
        CGRect frame = self.indicatorView.frame;
        frame.origin.x += deviation;
        self.indicatorView.frame = frame;
    } else {
        CGRect frame = self.indicatorView.frame;
        frame.origin.y += deviation;
        self.indicatorView.frame = frame;
    }
}

#pragma mark - UICollectionView代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //校验数据
    if (self.max == 0 || self.min >= self.max) {
        return 0;
    }
    
    //因为是从0开始，所以需要在最大值基础上 + 1
    NSInteger items = self.max - self.min;
    if (self.isDecimal) {
        //如果是一位小数类型，则数据扩大10倍
        return items * 10 + 1;
    } else {
        return items + 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RulerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:rulerCollectionViewCellIdentifier forIndexPath:indexPath];
    cell.index = indexPath.item;
    //刻度属性设置
    cell.shortScaleLength = self.shortScaleLength;
    cell.longScaleLength = self.longScaleLength;
    cell.scaleWidth = self.scaleWidth;
    cell.scaleColor = self.scaleColor;
    cell.shortScaleStart = self.shortScaleStart;
    cell.longScaleStart = self.longScaleStart;
    cell.numberFont = self.numberFont;
    cell.numberColor = self.numberColor;
    cell.numberDirection = self.numberDirection;
    cell.distanceFromScaleToNumber = self.distanceFromScaleToNumber;
    cell.isDecimal = self.isDecimal;
    cell.min = self.min;
    
    [cell setNeedsLayout];
    [cell makeCellHiddenText];
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = (kDirectionHorizontal ?
                      (scrollView.contentOffset.x + self.rulerCollectionView.contentInset.left) :
                      (scrollView.contentOffset.y + self.rulerCollectionView.contentInset.top)) ;
    
    NSInteger index = roundl(offset / (self.scaleWidth + self.distanceBetweenScale));
    self.selectIndex = index;
    
    double value = 0;
    //判断是否是小数
    if (self.isDecimal) {
        value = index * 1.0 / 10.0 + self.min;
    } else {
        value = index * 1.0 + self.min;
    }
    
    //保证数据在范围内
    if (value >= self.min && value <= self.max && self.activeDelegate) {
        if ([self.delegate respondsToSelector:@selector(rulerSelectValue:tag:)]) {
            [self.delegate rulerSelectValue:value tag:self.tag];
        }
//        NSLog(@"value = %lf, self.selectIndex = %li", value, self.selectIndex);
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self resetCell];
    //指示器视图居中显示
    [self centerPointView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    BOOL scrollToScrollStop = !scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
    if (scrollToScrollStop) {
        [self selectCell];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        BOOL dragToDragStop = scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
        if (dragToDragStop) {
            [self selectCell];
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self selectCell];
}

- (void)selectCell {
    if (self.selectionEnable) {
        NSInteger min = self.selectIndex - 5;
        NSInteger max = self.selectIndex + 5;
        for (NSInteger i=min; i<max; i++) {
            if (i >= 0 && i < [self collectionView:self.rulerCollectionView numberOfItemsInSection:0]) {
                RulerCollectionViewCell *cell = (RulerCollectionViewCell *)[self.rulerCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                [cell makeCellHiddenText];
            }
        }
        
        RulerCollectionViewCell *cell = (RulerCollectionViewCell *)[self.rulerCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectIndex inSection:0]];
        [cell makeCellSelect];
    }
}

- (void)resetCell {
    if (self.selectionEnable) {
        NSInteger min = self.selectIndex - 5;
        NSInteger max = self.selectIndex + 5;
        for (NSInteger i=min; i<max; i++) {
            if (i >= 0 && i < [self collectionView:self.rulerCollectionView numberOfItemsInSection:0]) {
                RulerCollectionViewCell *cell = (RulerCollectionViewCell *)[self.rulerCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                [cell setNeedsLayout];
            }
        }
    }
}

#pragma mark - 渐变透明层
- (void)addStartGradientLayer {
    //初始化CAGradientlayer对象，使它的大小为UIView的大小
    self.startGradientLayer = [CAGradientLayer layer];
    self.startGradientLayer.frame = self.bounds;
    
    //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
    [self.layer addSublayer:self.startGradientLayer];
    
    //设置渐变区域的起始和终止位置（颜色渐变范围为0-1）
    self.startGradientLayer.startPoint = CGPointMake(0, 0);
    self.startGradientLayer.endPoint = CGPointMake(1, 0);
    
    //设置颜色数组
    self.startGradientLayer.colors = @[(__bridge id)[UIColor whiteColor].CGColor,
                                       (__bridge id)[[UIColor whiteColor]colorWithAlphaComponent:0.0f].CGColor];
    
    //设置颜色分割点（区域渐变范围：0-1）
    self.startGradientLayer.locations = @[@(0.0f), @(0.3f)];
}

- (void)addEndGradientLayer {
    //初始化CAGradientlayer对象，使它的大小为UIView的大小
    self.endGradientLayer = [CAGradientLayer layer];
    self.endGradientLayer.frame = self.bounds;
    
    //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
    [self.layer addSublayer:self.endGradientLayer];
    
    //设置渐变区域的起始和终止位置（颜色渐变范围为0-1）
    self.endGradientLayer.startPoint = CGPointMake(0, 0);
    self.endGradientLayer.endPoint = CGPointMake(1, 0);
    
    //设置颜色数组
    self.endGradientLayer.colors = @[(__bridge id)[[UIColor whiteColor]colorWithAlphaComponent:0.0f].CGColor,
                                     (__bridge id)[UIColor whiteColor].CGColor];
    
    //设置颜色分割点（区域渐变范围：0-1）
    self.endGradientLayer.locations = @[@(0.7f), @(1.0f)];
}

#pragma mark - Tool
/** 传入字符串是否是数字 */
+ (BOOL)isPureInt:(NSString*)string {
    if (!string) {
        return false;
    }
    //string不是浮点型
    if (![string containsString:@"."]) {
        NSScanner *scan = [NSScanner scannerWithString:string];
        int val;
        return[scan scanInt:&val] && [scan isAtEnd];
    }
    //string是浮点型
    else {
        NSArray *numberArray = [string componentsSeparatedByString:@"."];
        if (numberArray.count != 2) {
            return false;
        }
        else {
            NSString *behindNumber = numberArray[1];
            //如果小数点后的数字等于0，则是整数
            return ([behindNumber integerValue] == 0);
        }
    }
}

@end
