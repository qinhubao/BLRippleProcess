//
//  GradientProgress.h
//  BLRippleProcess
//
//  Created by Bell Lake on 16/2/25.
//  Copyright © 2016年 SatanWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GPGrowStyle) {
    GrowStyleNone,
    GrowStyleLow,
    GrowStyleNormal,
    GrowStyleFast
};

@interface GradientProgress : UIView

/**
 *  圆环背景颜色 (圆弧0%时的背景颜色)
 */
@property (nonatomic, strong) UIColor *strokeColor;

/**
 *  渐变颜色组
 */
@property (nonatomic, copy) NSArray *colorArr;

// 起始角度和终止角度  默认是一个正圆环  从时钟6点钟开始顺时针走向增长
/**
 *  圆弧进度条起始角度 默认是-270度
 */
@property (nonatomic, assign) NSInteger startAngle;

/**
 *  圆弧进度条终止角度 默认是90度
 */
@property (nonatomic, assign) NSInteger endAngle;

- (instancetype)initWithFrame:(CGRect)frame;

/**
 *  设置渐变颜色组
 *
 *  @param colors UIColor对象数组, 每个对象类型需要为UIColor 否则无效
 */
- (void)setColorArr:(NSArray *)colors;

/**
 *  设置动画执行速度
 *
 *  @param style 执行速度
 */
- (void)setAnimationSpeed:(GPGrowStyle)style;

/**
 *  获取当前百分值 返回0-100直接的值
 *
 *  @return 返回当前百分值
 */
- (CGFloat)percent;

/**
 *  设置进度条百分比
 *
 *  @param percent 百分百的值0-100之间的数值
 */
- (void)setPercent:(CGFloat)percent;
@end
