//
//  RulerCollectionViewCell.h
//  TYFitFore
//
//  Created by apple on 2018/7/5.
//  Copyright © 2018年 tangpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIColorFromHex(s) [UIColor colorWithRed:(((s & 0xFF0000) >> 16 )) / 255.0 green:((( s & 0xFF00 ) >> 8 )) / 255.0 blue:(( s & 0xFF )) / 255.0 alpha:1.0]
#define SCREEN_WIDTH_RULER ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT_RULER ([[UIScreen mainScreen] bounds].size.height)

typedef NS_ENUM(NSInteger, RulerNumberDirection) {
    numberTop = 0,                          //水平方向：数字在上，刻度尺在下
    numberBottom,                           //水平方向：数字在下，刻度尺在上
    numberLeft,                             //垂直方向：数字在左，刻度尺在右
    numberRight                             //垂直方向：数字在右，刻度尺在左
};

@interface RulerCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) CGFloat shortScaleLength;                         /**< 短刻度长度  */
@property (nonatomic, assign) CGFloat longScaleLength;                          /**< 长刻度长度  */
@property (nonatomic, assign) CGFloat scaleWidth;                               /**< 刻度尺宽度  */
@property (nonatomic, assign) CGFloat shortScaleStart;                          /**< 短刻度起始位置  */
@property (nonatomic, assign) CGFloat longScaleStart;                           /**< 长刻度起始位置  */
@property (nonatomic, strong) UIColor *scaleColor;                              /**< 刻度颜色  */
@property (nonatomic, strong) UIFont *numberFont;                               /**< 数字字体  */
@property (nonatomic, strong) UIColor *numberColor;                             /**< 数字颜色  */
@property (nonatomic, assign) CGFloat distanceFromScaleToNumber;                /**< 刻度和数字之间的距离  */
@property (nonatomic, assign) RulerNumberDirection numberDirection;             /**< 数字方向  */
@property (nonatomic, assign) NSInteger min;                                    /**< 最小值  */
@property (nonatomic, assign) NSInteger max;                                    /**< 最大值  */
@property (nonatomic, assign) BOOL reverse; 

@property (nonatomic, assign) NSInteger index;                                  /**< cell下标  */
@property (nonatomic, assign) BOOL isDecimal;                                   /**< 保留一位小数类型  */

/** 选中当前cell */
- (void)makeCellSelect;
/** 隐藏当前cell的文字 */
- (void)makeCellHiddenText;

@end
