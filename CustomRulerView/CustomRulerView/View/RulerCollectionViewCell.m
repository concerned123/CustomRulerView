//
//  RulerCollectionViewCell.m
//  TYFitFore
//
//  Created by apple on 2018/7/5.
//  Copyright © 2018年 tangpeng. All rights reserved.
//

#import "RulerCollectionViewCell.h"

#define kHorizontalCell (self.numberDirection == numberTop || self.numberDirection == numberBottom)

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
        if (self.isDecimal) {
//            text = [NSString stringWithFormat:@"%ld", self.index/10 + self.min];
            NSInteger showIndex = self.index/10 + self.min;
            if (self.reverse) {
                showIndex = self.max - showIndex + self.min;
                text = [NSString stringWithFormat:@"%ld", showIndex];
            } else {
                text = [NSString stringWithFormat:@"%ld", self.index/10 + self.min];
            }
        } else {
//            text = [NSString stringWithFormat:@"%ld", (long)self.index + self.min];
            NSInteger showIndex = self.index + self.min;
            if (self.reverse) {
                text = [NSString stringWithFormat:@"%ld", (long)(self.max - showIndex + self.min)];
            } else {
                text = [NSString stringWithFormat:@"%ld", (long)showIndex];
            }
        }
        
        //字体
        CGSize size = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH_RULER, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.numberFont} context:nil].size;
        
        if (kHorizontalCell) {
            //水平方向
            CGFloat startY = 0;
            if (self.numberDirection == numberTop) {
                //数字在上面，刻度尺在下方
                startY = self.shortScaleStart - self.distanceFromScaleToNumber - size.height;
            } else if (self.numberDirection == numberBottom) {
                //数字在下面，刻度尺在上方
                startY = self.shortScaleStart + self.shortScaleLength + self.distanceFromScaleToNumber;
            }
            self.textLayer.frame = CGRectMake((CGRectGetWidth(self.contentView.frame) - size.width)/2.0, startY, size.width, size.height);
        } else {
            //垂直方向
            CGFloat startX = 0;
            if (self.numberDirection == numberLeft) {
                //数字在左边，刻度尺在右边
                startX = self.shortScaleStart - self.distanceFromScaleToNumber - size.width;
            } else if (self.numberDirection == numberRight) {
                //数字在右边，刻度尺在左边
                startX = self.shortScaleStart + self.shortScaleLength + self.distanceFromScaleToNumber;
            }
            self.textLayer.frame = CGRectMake(startX, (CGRectGetHeight(self.contentView.frame) - size.height)/2.0, size.width, size.height);
        }
        
        self.textLayer.string = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: self.numberFont, NSForegroundColorAttributeName: self.numberColor}];
        [self.contentView.layer addSublayer:self.textLayer];
    } else {
        self.textLayer.string = nil;
        [self.textLayer removeFromSuperlayer];
    }

    self.selectTextLayer.string = nil;
    [self.selectTextLayer removeFromSuperlayer];
    
    //刻度尺
    CGFloat length = ((self.index % 5 == 0) ? self.longScaleLength : self.shortScaleLength);
    CGFloat start = ((self.index % 5 == 0) ? self.longScaleStart : self.shortScaleStart);
    self.ruleImageView.frame = kHorizontalCell ? CGRectMake(0, start, self.scaleWidth, length) : CGRectMake(start, 0, length, self.scaleWidth);
    self.ruleImageView.layer.cornerRadius = self.scaleWidth/2.0;
    self.ruleImageView.backgroundColor = self.scaleColor;
}

#pragma mark - 选中当前cell
- (void)makeCellSelect {
    
    self.selectTextLayer = nil;
    NSString *text = @"";
    if (self.isDecimal) {
//        text = [NSString stringWithFormat:@"%.1lf", self.index/10.0 + self.min];
        double showIndex = self.index/10.0 + self.min;
        if (self.reverse) {
            showIndex = self.max - showIndex + self.min;
            text = [NSString stringWithFormat:@"%.1lf", showIndex];
        } else {
            text = [NSString stringWithFormat:@"%.1lf", self.index/10.0 + self.min];
        }
    } else {
//        text = [NSString stringWithFormat:@"%ld", (long)self.index + self.min];
        NSInteger showIndex = self.index + self.min;
        if (self.reverse) {
            text = [NSString stringWithFormat:@"%ld", (long)(self.max - showIndex + self.min)];
        } else {
            text = [NSString stringWithFormat:@"%ld", (long)showIndex];
        }
    }
    CGSize size = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH_RULER, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Semibold" size:18]} context:nil].size;
    
    if (kHorizontalCell) {
        //水平方向
        CGFloat startY = 0;
        if (self.numberDirection == numberTop) {
            //数字在上方，刻度尺在下方
            startY = self.shortScaleStart - self.distanceFromScaleToNumber - size.height - 12;
        } else if (self.numberDirection == numberBottom) {
            //数字在下方，刻度尺在上方
            startY = self.shortScaleStart + self.shortScaleLength + self.distanceFromScaleToNumber + 12;
        }
        self.selectTextLayer.frame = CGRectMake((CGRectGetWidth(self.contentView.frame) - size.width)/2.0, startY, size.width, size.height);
    } else {
        //垂直方向
        CGFloat startX = 0;
        if (self.numberDirection == numberLeft) {
            //数字在左边，刻度尺在右边
            startX = self.shortScaleStart - self.distanceFromScaleToNumber - size.width - 12;
        } else if (self.numberDirection == numberRight) {
            //数字在右边，刻度尺在左边
            startX = self.shortScaleStart + self.shortScaleLength + self.distanceFromScaleToNumber + 12;
        } 
        self.selectTextLayer.frame = CGRectMake(startX, (CGRectGetHeight(self.contentView.frame) - size.height)/2.0, size.width, size.height);
    }
    
    self.selectTextLayer.string = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Semibold" size:18], NSForegroundColorAttributeName: UIColorFromHex(0x20C6BA)}];
    [self.contentView.layer addSublayer:self.selectTextLayer];
    self.textLayer.string = nil;
    [self.textLayer removeFromSuperlayer];
}

#pragma mark - 隐藏当前cell的文字
- (void)makeCellHiddenText {
    self.textLayer.string = nil;
    [self.textLayer removeFromSuperlayer];
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

@end
