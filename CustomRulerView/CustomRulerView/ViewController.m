//
//  ViewController.m
//  CustomRulerView
//
//  Created by apple on 2018/7/26.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ViewController.h"

#import "RulerView.h"

@interface ViewController () <RulerViewDelegate>

@property (nonatomic, strong) RulerView *numberTopRulerView;                    //数字居上带选中刻度尺
@property (nonatomic, strong) RulerView *numberBottomRulerView;                 //数字居下
@property (nonatomic, strong) RulerView *numberLeftRulerView;                   //数字居左
@property (nonatomic, strong) RulerView *numberRightRulerView;                  //数字居右

@property (nonatomic, strong) UILabel *numberBottomRulerDefaultLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.numberTopRulerView];
    [self.view addSubview:self.numberBottomRulerView];
    [self.view addSubview:self.numberLeftRulerView];
    [self.view addSubview:self.numberRightRulerView];
    
    [self.view addSubview:self.numberBottomRulerDefaultLabel];
}

#pragma mark - 代理方法
- (void)rulerSelectValue:(double)value tag:(NSInteger)tag {
    if (tag == 1) {
        self.numberBottomRulerDefaultLabel.text = [NSString stringWithFormat:@"选中值：%li", (long)value];
    } else if (tag == 3) {
        
    }
}

#pragma mark - getter
- (RulerView *)numberTopRulerView {
    if (!_numberTopRulerView) {
        _numberTopRulerView = [[RulerView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH_RULER, 65)];
        //刻度高度
        _numberTopRulerView.shortScaleLength = 7;
        _numberTopRulerView.longScaleLength = 11;
        //刻度宽度
        _numberTopRulerView.scaleWidth = 2;
        //刻度起始位置
        _numberTopRulerView.shortScaleStart = 58;
        _numberTopRulerView.longScaleStart = 54;
        //刻度颜色
        _numberTopRulerView.scaleColor = UIColorFromHex(0xdae0ed);
        //刻度之间的距离
        _numberTopRulerView.distanceBetweenScale = 4;
        //刻度距离数字的距离
        _numberTopRulerView.distanceFromScaleToNumber = 13;
        //指示视图属性设置
        _numberTopRulerView.pointSize = CGSizeMake(2, 20);
        _numberTopRulerView.pointColor = UIColorFromHex(0x20c6ba);
        _numberTopRulerView.pointStart = 45;
        //文字属性
        _numberTopRulerView.numberFont = [UIFont systemFontOfSize:11];
        _numberTopRulerView.numberColor = UIColorFromHex(0x4A4A4A);
        //数字所在位置方向
        _numberTopRulerView.numberDirection = numberTop;
        
        //取值范围
        _numberTopRulerView.max = 300;
        _numberTopRulerView.min = 20;
        //默认值
        _numberTopRulerView.defaultNumber = 105.6;
        //使用小数类型
        _numberTopRulerView.isDecimal = YES;
        //选中
        _numberTopRulerView.selectionEnable = YES;
        //使用渐变背景
        _numberTopRulerView.useGradient = YES;
        _numberTopRulerView.backgroundColor = [UIColorFromHex(0xE4E6EB) colorWithAlphaComponent:0.3f];
        
        _numberTopRulerView.tag = 0;
        _numberTopRulerView.delegate = self;
    }
    return _numberTopRulerView;
}

- (RulerView *)numberBottomRulerView {
    if (!_numberBottomRulerView) {
        _numberBottomRulerView = [[RulerView alloc] initWithFrame:CGRectMake(0, 220, SCREEN_WIDTH_RULER, 100)];
        //刻度高度
        _numberBottomRulerView.shortScaleLength = 17.5;
        _numberBottomRulerView.longScaleLength = 25;
        //刻度宽度
        _numberBottomRulerView.scaleWidth = 2;
        //刻度起始位置
        _numberBottomRulerView.shortScaleStart = 25;
        _numberBottomRulerView.longScaleStart = 25;
        //刻度颜色
        _numberBottomRulerView.scaleColor = UIColorFromHex(0xdae0ed);
        //刻度之间的距离
        _numberBottomRulerView.distanceBetweenScale = 8;
        //刻度距离数字的距离
        _numberBottomRulerView.distanceFromScaleToNumber = 35;
        //指示视图属性设置
        _numberBottomRulerView.pointSize = CGSizeMake(4, 40);
        _numberBottomRulerView.pointColor = UIColorFromHex(0x20c6ba);
        _numberBottomRulerView.pointStart = 20;
        //文字属性
        _numberBottomRulerView.numberFont = [UIFont systemFontOfSize:11];
        _numberBottomRulerView.numberColor = UIColorFromHex(0x617272);
        //数字所在位置方向
        _numberBottomRulerView.numberDirection = numberBottom;
        
        //取值范围
        _numberBottomRulerView.max = 5000;
        _numberBottomRulerView.min = 1000;
        //默认值
        _numberBottomRulerView.defaultNumber = 2522;
        _numberBottomRulerView.backgroundColor = [UIColorFromHex(0xE4E6EB) colorWithAlphaComponent:0.3f];
        _numberBottomRulerView.tag = 1;
        _numberBottomRulerView.delegate = self;
    }
    return _numberBottomRulerView;
}

- (RulerView *)numberLeftRulerView {
    if (!_numberLeftRulerView) {
        _numberLeftRulerView = [[RulerView alloc] initWithFrame:CGRectMake(20, 350, 120, SCREEN_HEIGHT_RULER - 350)];
        //刻度高度
        _numberLeftRulerView.shortScaleLength = 12;
        _numberLeftRulerView.longScaleLength = 16;
        //刻度宽度
        _numberLeftRulerView.scaleWidth = 2;
        //刻度起始位置
        _numberLeftRulerView.shortScaleStart = 78;
        _numberLeftRulerView.longScaleStart = 74;
        //刻度颜色
        _numberLeftRulerView.scaleColor = UIColorFromHex(0xdae0ed);
        //刻度之间的距离
        _numberLeftRulerView.distanceBetweenScale = 4;
        //刻度距离数字的距离
        _numberLeftRulerView.distanceFromScaleToNumber = 13;
        //指示视图属性设置
        _numberLeftRulerView.pointSize = CGSizeMake(2, 20);
        _numberLeftRulerView.pointColor = UIColorFromHex(0x20c6ba);
        _numberLeftRulerView.pointStart = 65;
        //文字属性
        _numberLeftRulerView.numberFont = [UIFont systemFontOfSize:11];
        _numberLeftRulerView.numberColor = UIColorFromHex(0x4A4A4A);
        //数字所在位置方向
        _numberLeftRulerView.numberDirection = numberLeft;
        
        //取值范围
        _numberLeftRulerView.max = 300;
        _numberLeftRulerView.min = 20;
        //默认值
        _numberLeftRulerView.defaultNumber = 105.8;
        //使用小数类型
        _numberLeftRulerView.isDecimal = YES;
        //选中
        _numberLeftRulerView.selectionEnable = YES;
        
        _numberLeftRulerView.backgroundColor = [UIColorFromHex(0xE4E6EB) colorWithAlphaComponent:0.3f];
        _numberLeftRulerView.tag = 2;
        _numberLeftRulerView.delegate = self;
    }
    return _numberLeftRulerView;
}

- (RulerView *)numberRightRulerView {
    if (!_numberRightRulerView) {
        CGFloat width = 150;
        _numberRightRulerView = [[RulerView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH_RULER - 20 - width, 350, width, SCREEN_HEIGHT_RULER - 350)];
        //刻度高度
        _numberRightRulerView.shortScaleLength = 17.5;
        _numberRightRulerView.longScaleLength = 25;
        //刻度宽度
        _numberRightRulerView.scaleWidth = 2;
        //刻度起始位置
        _numberRightRulerView.shortScaleStart = 25;
        _numberRightRulerView.longScaleStart = 25;
        //刻度颜色
        _numberRightRulerView.scaleColor = UIColorFromHex(0xdae0ed);
        //刻度之间的距离
        _numberRightRulerView.distanceBetweenScale = 8;
        //刻度距离数字的距离
        _numberRightRulerView.distanceFromScaleToNumber = 35;
        //指示视图属性设置
        _numberRightRulerView.pointSize = CGSizeMake(4, 40);
        _numberRightRulerView.pointColor = UIColorFromHex(0x20c6ba);
        _numberRightRulerView.pointStart = 20;
        //文字属性
        _numberRightRulerView.numberFont = [UIFont systemFontOfSize:11];
        _numberRightRulerView.numberColor = UIColorFromHex(0x617272);
        //数字所在位置方向
        _numberRightRulerView.numberDirection = numberRight;
        
        //取值范围
        _numberRightRulerView.max = 5000;
        _numberRightRulerView.min = 1000;
        //默认值
        _numberRightRulerView.defaultNumber = 3686;
        _numberRightRulerView.selectionEnable = YES;
        _numberRightRulerView.backgroundColor = [UIColorFromHex(0xE4E6EB) colorWithAlphaComponent:0.3f];
        _numberRightRulerView.tag = 3;
        _numberRightRulerView.delegate = self;
    }
    return _numberRightRulerView;
}

- (UILabel *)numberBottomRulerDefaultLabel {
    if (!_numberBottomRulerDefaultLabel) {
        _numberBottomRulerDefaultLabel = [[UILabel alloc] init];
        _numberBottomRulerDefaultLabel.font = [UIFont systemFontOfSize:15];
        _numberBottomRulerDefaultLabel.textColor = UIColorFromHex(0x999999);
        CGFloat height = [UIFont systemFontOfSize:15].lineHeight;
        _numberBottomRulerDefaultLabel.frame = CGRectMake(0, CGRectGetMinY(_numberBottomRulerView.frame) - height - 5, SCREEN_WIDTH_RULER, height);
        _numberBottomRulerDefaultLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _numberBottomRulerDefaultLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
