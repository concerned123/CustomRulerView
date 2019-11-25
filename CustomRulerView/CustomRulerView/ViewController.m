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
    
    NSLog(@"value = %lf", value);
}

#pragma mark - getter
- (RulerView *)numberTopRulerView {
    if (!_numberTopRulerView) {
        _numberTopRulerView = [[RulerView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH_RULER, 65)];
        _numberTopRulerView.backgroundColor = [UIColorFromHex(0xE4E6EB) colorWithAlphaComponent:0.3f];
        _numberTopRulerView.tag = 0;
        _numberTopRulerView.delegate = self;
        
        RulerConfig *config = [[RulerConfig alloc] init];
        //刻度高度
        config.shortScaleLength = 7;
        config.longScaleLength = 11;
        //刻度宽度
        config.scaleWidth = 2;
        //刻度起始位置
        config.shortScaleStart = 58;
        config.longScaleStart = 54;
        //刻度颜色
        config.scaleColor = UIColorFromHex(0xdae0ed);
        //刻度之间的距离
        config.distanceBetweenScale = 4;
        //刻度距离数字的距离
        config.distanceFromScaleToNumber = 13;
        //指示视图属性设置
        config.pointSize = CGSizeMake(2, 20);
        config.pointColor = UIColorFromHex(0x20c6ba);
        config.pointStart = 45;
        //文字属性
        config.numberFont = [UIFont systemFontOfSize:11];
        config.numberColor = UIColorFromHex(0x4A4A4A);
        //数字所在位置方向
        config.numberDirection = numberTop;
        
        //取值范围
        config.max = 200;
        config.min = 0;
        //默认值
        config.defaultNumber = 57;
        //使用小数类型
        config.isDecimal = YES;
        //选中
        config.selectionEnable = YES;
        //使用渐变背景
        config.useGradient = YES;
        config.infiniteLoop = YES;
        
        _numberTopRulerView.rulerConfig = config;
    }
    return _numberTopRulerView;
}

- (RulerView *)numberBottomRulerView {
    if (!_numberBottomRulerView) {
        _numberBottomRulerView = [[RulerView alloc] initWithFrame:CGRectMake(0, 220, SCREEN_WIDTH_RULER, 100)];
        _numberBottomRulerView.backgroundColor = [UIColorFromHex(0xE4E6EB) colorWithAlphaComponent:0.3f];
        _numberBottomRulerView.tag = 1;
        _numberBottomRulerView.delegate = self;
        
        RulerConfig *config = [[RulerConfig alloc] init];
        //刻度高度
        config.shortScaleLength = 17.5;
        config.longScaleLength = 25;
        //刻度宽度
        config.scaleWidth = 2;
        //刻度起始位置
        config.shortScaleStart = 25;
        config.longScaleStart = 25;
        //刻度颜色
        config.scaleColor = UIColorFromHex(0xdae0ed);
        //刻度之间的距离
        config.distanceBetweenScale = 8;
        //刻度距离数字的距离
        config.distanceFromScaleToNumber = 35;
        //指示视图属性设置
        config.pointSize = CGSizeMake(4, 40);
        config.pointColor = UIColorFromHex(0x20c6ba);
        config.pointStart = 20;
        //文字属性
        config.numberFont = [UIFont systemFontOfSize:11];
        config.numberColor = UIColorFromHex(0x617272);
        //数字所在位置方向
        config.numberDirection = numberBottom;
        
        //取值范围
        config.max = 50;
        config.min = 0;
        //默认值
        config.defaultNumber = 10;
        config.infiniteLoop = YES;
        config.offset = 5;
        
        _numberBottomRulerView.rulerConfig = config;
    }
    return _numberBottomRulerView;
}

- (RulerView *)numberLeftRulerView {
    if (!_numberLeftRulerView) {
        _numberLeftRulerView = [[RulerView alloc] initWithFrame:CGRectMake(20, 350, 120, SCREEN_HEIGHT_RULER - 350)];
        _numberLeftRulerView.backgroundColor = [UIColorFromHex(0xE4E6EB) colorWithAlphaComponent:0.3f];
        _numberLeftRulerView.tag = 2;
        _numberLeftRulerView.delegate = self;
        
        RulerConfig *config = [[RulerConfig alloc] init];
        //刻度高度
        config.shortScaleLength = 12;
        config.longScaleLength = 16;
        //刻度宽度
        config.scaleWidth = 2;
        //刻度起始位置
        config.shortScaleStart = 78;
        config.longScaleStart = 74;
        //刻度颜色
        config.scaleColor = UIColorFromHex(0xdae0ed);
        //刻度之间的距离
        config.distanceBetweenScale = 4;
        //刻度距离数字的距离
        config.distanceFromScaleToNumber = 13;
        //指示视图属性设置
        config.pointSize = CGSizeMake(2, 20);
        config.pointColor = UIColorFromHex(0x20c6ba);
        config.pointStart = 65;
        //文字属性
        config.numberFont = [UIFont systemFontOfSize:11];
        config.numberColor = UIColorFromHex(0x4A4A4A);
        //数字所在位置方向
        config.numberDirection = numberLeft;
        
        //取值范围
        config.max = 100;
        config.min = 0;
        //默认值
        config.defaultNumber = 25.2;
        //使用小数类型
        config.isDecimal = YES;
        //选中
        config.selectionEnable = YES;
        //数字顺序相反
        config.reverse = YES;
        config.infiniteLoop = YES;
        
        _numberLeftRulerView.rulerConfig = config;
    }
    return _numberLeftRulerView;
}

- (RulerView *)numberRightRulerView {
    if (!_numberRightRulerView) {
        CGFloat width = 150;
        _numberRightRulerView = [[RulerView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH_RULER - 20 - width, 350, width, SCREEN_HEIGHT_RULER - 350)];
        _numberRightRulerView.backgroundColor = [UIColorFromHex(0xE4E6EB) colorWithAlphaComponent:0.3f];
        _numberRightRulerView.tag = 3;
        _numberRightRulerView.delegate = self;
        
        RulerConfig *config = [[RulerConfig alloc] init];
        //刻度高度
        config.shortScaleLength = 17.5;
        config.longScaleLength = 25;
        //刻度宽度
        config.scaleWidth = 2;
        //刻度起始位置
        config.shortScaleStart = 25;
        config.longScaleStart = 25;
        //刻度颜色
        config.scaleColor = UIColorFromHex(0xdae0ed);
        //刻度之间的距离
        config.distanceBetweenScale = 8;
        //刻度距离数字的距离
        config.distanceFromScaleToNumber = 35;
        //指示视图属性设置
        config.pointSize = CGSizeMake(4, 40);
        config.pointColor = UIColorFromHex(0x20c6ba);
        config.pointStart = 20;
        //文字属性
        config.numberFont = [UIFont systemFontOfSize:11];
        config.numberColor = UIColorFromHex(0x617272);
        //数字所在位置方向
        config.numberDirection = numberRight;
        
        //取值范围
        config.max = 5000;
        config.min = 1000;
        //默认值
        config.defaultNumber = 3686;
        config.selectionEnable = YES;
        
        _numberRightRulerView.rulerConfig = config;
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
