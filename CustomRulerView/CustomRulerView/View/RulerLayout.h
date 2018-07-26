//
//  RulerLayout.h
//  TYFitFore
//
//  Created by apple on 2018/7/5.
//  Copyright © 2018年 tangpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RulerLayout : UICollectionViewLayout

@property (nonatomic, assign) CGFloat spacing;                                      /**< cell间距  */
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;      /**< 滑动方向  */

@end
