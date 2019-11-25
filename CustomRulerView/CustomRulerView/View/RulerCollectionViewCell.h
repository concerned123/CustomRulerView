//
//  RulerCollectionViewCell.h
//  TYFitFore
//
//  Created by apple on 2018/7/5.
//  Copyright © 2018年 tangpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RulerConfig;

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

@property (nonatomic, strong) RulerConfig *rulerConfig;
@property (nonatomic, assign) NSInteger index;                                      /**< cell下标  */

/** 选中当前cell */
- (void)makeCellSelect;
/** 隐藏当前cell的文字 */
- (void)makeCellHiddenText;

@end
