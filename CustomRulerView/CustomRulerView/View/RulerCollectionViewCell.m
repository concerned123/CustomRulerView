//
//  RulerCollectionViewCell.m
//  TYFitFore
//
//  Created by apple on 2018/7/5.
//  Copyright © 2018年 tangpeng. All rights reserved.
//

#import "RulerCollectionViewCell.h"
#import "RulerView.h"

#define kNumberTop (self.rulerConfig.numberDirection == numberTop)
#define kNumberBottom (self.rulerConfig.numberDirection == numberBottom)
#define kNumberLeft (self.rulerConfig.numberDirection == numberLeft)
#define kNumberRight (self.rulerConfig.numberDirection == numberRight)
#define kHorizontalCell (kNumberTop || kNumberBottom)

@interface RulerCollectionViewCell ()

@property (nonatomic, strong) UIImageView *ruleImageView;
@property (nonatomic, strong) CATextLayer *textLayer;
@property (nonatomic, strong) CATextLayer *selectTextLayer;

@end

@implementation RulerCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.ruleImageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.index % 10 == 0) {
        NSString *text = @"";
        if (self.rulerConfig.isDecimal) {
            NSInteger showIndex = self.index/10 + self.rulerConfig.min;
            if (self.rulerConfig.reverse) {
                showIndex = self.rulerConfig.max - showIndex + self.rulerConfig.min;
                text = [NSString stringWithFormat:@"%ld", showIndex];
            } else {
                text = [NSString stringWithFormat:@"%ld", self.index/10 + self.rulerConfig.min];
            }
        } else {
            NSInteger showIndex = self.index + self.rulerConfig.min;
            if (self.rulerConfig.reverse) {
                text = [NSString stringWithFormat:@"%ld", (long)(self.rulerConfig.max - showIndex + self.rulerConfig.min)];
            } else {
                text = [NSString stringWithFormat:@"%ld", (long)showIndex];
            }
        }
        
        //字体 (采用当前最大值的位数显示字体)
        CGSize size = [[self maxString] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH_RULER, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.rulerConfig.numberFont} context:nil].size;
        
        if (kHorizontalCell) {
            //水平方向
            CGFloat startY = 0;
            if (kNumberTop) {
                //数字在上面，刻度尺在下方
                startY = self.rulerConfig.shortScaleStart - self.rulerConfig.distanceFromScaleToNumber - size.height;
            } else if (kNumberBottom) {
                //数字在下面，刻度尺在上方
                startY = self.rulerConfig.shortScaleStart + self.rulerConfig.shortScaleLength + self.rulerConfig.distanceFromScaleToNumber;
            }
            self.textLayer.frame = CGRectMake((CGRectGetWidth(self.contentView.frame) - size.width)/2.0, startY, size.width, size.height);
        } else {
            //垂直方向
            CGFloat startX = 0;
            if (kNumberLeft) {
                //数字在左边，刻度尺在右边
                startX = self.rulerConfig.shortScaleStart - self.rulerConfig.distanceFromScaleToNumber - size.width;
            } else if (kNumberRight) {
                //数字在右边，刻度尺在左边
                startX = self.rulerConfig.shortScaleStart + self.rulerConfig.shortScaleLength + self.rulerConfig.distanceFromScaleToNumber;
            }
            self.textLayer.frame = CGRectMake(startX, (CGRectGetHeight(self.contentView.frame) - size.height)/2.0, size.width, size.height);
        }
        
        self.textLayer.string = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: self.rulerConfig.numberFont, NSForegroundColorAttributeName: self.rulerConfig.numberColor}];
        self.textLayer.actions = @{@"contents": [NSNull null]};
        if (!self.textLayer.superlayer) {
            [self.contentView.layer addSublayer:self.textLayer];
        }
    } else {
        self.textLayer.string = nil;
    }

    self.selectTextLayer.string = nil;
    [self.selectTextLayer removeFromSuperlayer];
    
    //刻度尺
    CGFloat length = ((self.index % 5 == 0) ? self.rulerConfig.longScaleLength : self.rulerConfig.shortScaleLength);
    CGFloat start = ((self.index % 5 == 0) ? self.rulerConfig.longScaleStart : self.rulerConfig.shortScaleStart);
    self.ruleImageView.frame = kHorizontalCell ? CGRectMake(0, start, self.rulerConfig.scaleWidth, length) : CGRectMake(start, 0, length, self.rulerConfig.scaleWidth);
    self.ruleImageView.layer.cornerRadius = self.rulerConfig.scaleWidth/2.0;
    self.ruleImageView.backgroundColor = self.rulerConfig.scaleColor;
}

#pragma mark - 选中当前cell
- (void)makeCellSelect {
    
    self.selectTextLayer = nil;
    NSString *text = @"";
    if (self.rulerConfig.isDecimal) {
        double showIndex = self.index/10.0 + self.rulerConfig.min;
        if (self.rulerConfig.reverse) {
            showIndex = self.rulerConfig.max - showIndex + self.rulerConfig.min;
            text = [self notRounding:showIndex afterPoint:1];
        } else {
            text = [self notRounding:self.index/10.0 + self.rulerConfig.min afterPoint:1];
        }
    } else {
        NSInteger showIndex = self.index + self.rulerConfig.min;
        if (self.rulerConfig.reverse) {
            text = [NSString stringWithFormat:@"%ld", (long)(self.rulerConfig.max - showIndex + self.rulerConfig.min)];
        } else {
            text = [NSString stringWithFormat:@"%ld", (long)showIndex];
        }
    }
    CGSize size = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH_RULER, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Semibold" size:18]} context:nil].size;
    
    if (kHorizontalCell) {
        //水平方向
        CGFloat startY = 0;
        if (kNumberTop) {
            //数字在上方，刻度尺在下方
            startY = self.rulerConfig.shortScaleStart - self.rulerConfig.distanceFromScaleToNumber - size.height - 12;
        } else if (kNumberBottom) {
            //数字在下方，刻度尺在上方
            startY = self.rulerConfig.shortScaleStart + self.rulerConfig.shortScaleLength + self.rulerConfig.distanceFromScaleToNumber + 12;
        }
        self.selectTextLayer.frame = CGRectMake((CGRectGetWidth(self.contentView.frame) - size.width)/2.0, startY, size.width, size.height);
    } else {
        //垂直方向
        CGFloat startX = 0;
        if (kNumberLeft) {
            //数字在左边，刻度尺在右边
            startX = self.rulerConfig.shortScaleStart - self.rulerConfig.distanceFromScaleToNumber - size.width - 12;
        } else if (kNumberRight) {
            //数字在右边，刻度尺在左边
            startX = self.rulerConfig.shortScaleStart + self.rulerConfig.shortScaleLength + self.rulerConfig.distanceFromScaleToNumber + 12;
        } 
        self.selectTextLayer.frame = CGRectMake(startX, (CGRectGetHeight(self.contentView.frame) - size.height)/2.0, size.width, size.height);
    }
    
    self.selectTextLayer.string = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Semibold" size:18], NSForegroundColorAttributeName: UIColorFromHex(0x20C6BA)}];
    self.selectTextLayer.actions = @{@"contents": [NSNull null]};
    [self.contentView.layer addSublayer:self.selectTextLayer];
    self.textLayer.string = nil;
}

#pragma mark - 隐藏当前cell的文字
- (void)makeCellHiddenText {
    self.textLayer.string = nil;
}

#pragma mark - getter
- (UIImageView *)ruleImageView {
    if (!_ruleImageView) {
        _ruleImageView = [[UIImageView alloc] init];
    }
    return _ruleImageView;
}

- (CATextLayer *)textLayer {
    if (!_textLayer) {
        _textLayer = [CATextLayer layer];
        _textLayer.contentsScale = [UIScreen mainScreen].scale;
        _textLayer.alignmentMode = @"center";
    }
    return _textLayer;
}

- (CATextLayer *)selectTextLayer {
    if (!_selectTextLayer) {
        _selectTextLayer = [CATextLayer layer];
        _selectTextLayer.contentsScale = [UIScreen mainScreen].scale;
    }
    return _selectTextLayer;
}

#pragma mark - other
/** 根据最大值，求出当前位数的最大值 */
- (NSString *)maxString {
    NSInteger num = self.rulerConfig.max;
    NSMutableString *maxNumberString = [NSMutableString string];
    
    while (num > 0) {
        [maxNumberString appendFormat:@"9"];
        num = num / 10;
    }
    
    return maxNumberString;
}

- (NSString *)notRounding:(float)price afterPoint:(int)position {
//    price:需要处理的数字，
//    position：保留小数点第几位
//    NSRoundDown代表的就是 只舍不入
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                                                                                      scale:position
                                                                                           raiseOnExactness:NO
                                                                                            raiseOnOverflow:NO
                                                                                           raiseOnUnderflow:NO
                                                                                        raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;

    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@", roundedOunces];
}

@end
