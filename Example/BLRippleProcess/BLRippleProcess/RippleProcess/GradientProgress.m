//
//  gradientProgress.m
//  BLRippleProcess
//
//  Created by Bell Lake on 16/2/25.
//  Copyright © 2016年 SatanWoo. All rights reserved.
//

#import "GradientProgress.h"

#define degreesToRadians(x) (M_PI*(x)/180.0) //把角度转换成PI的方式
#define  PROGREESS_WIDTH 80 //圆直径
#define PROGRESS_LINE_WIDTH 4 //弧线的宽度
#define PROCESS_COLOR ([UIColor whiteColor])
#define MAIN_BLUE ([UIColor blueColor])

@interface GradientProgress ()
{
    CGFloat stepAddCount;
    CGFloat currentPercent;
    CAGradientLayer *gradientLayer1;
    CAGradientLayer *gradientLayer2;
}

@property (nonatomic, strong) CAShapeLayer *trackLayer;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) NSTimer *gradTimer;
@property (nonatomic, assign) GPGrowStyle growStyle;

@property (nonatomic, assign) CGFloat process;

@end

@implementation GradientProgress

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

/**
*  initialization
*
*  @return 对象
*/
- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

#pragma mark - Private Method
- (void)commonInit {

    self.growStyle = GrowStyleLow;
    self.strokeColor = [UIColor whiteColor];
    [self.layer addSublayer:self.trackLayer];
    CALayer *gradientLayer = [CALayer layer];
    
    gradientLayer1 =  [CAGradientLayer layer];
    // +1.5是为了弥补画圆和设置线条过程中带来的误差进行弥补所设如其他角度开始可自行调整
    gradientLayer1.frame = CGRectMake(0, 0, self.frame.size.width/2 +1.5, self.frame.size.height);
    [gradientLayer1 setColors:[NSArray arrayWithObjects:(id)[[UIColor redColor] CGColor],[(id)[UIColor colorWithRed:0xfd/255.0 green:0xe8/255.0 blue:0x02/255.0 alpha:1.0] CGColor], nil]];
    [gradientLayer1 setLocations:@[@0.5,@0.9,@1 ]];
    [gradientLayer1 setStartPoint:CGPointMake(0.5, 1)];
    [gradientLayer1 setEndPoint:CGPointMake(0.5, 0)];
    [gradientLayer addSublayer:gradientLayer1];
    
    gradientLayer2 =  [CAGradientLayer layer];
    [gradientLayer2 setLocations:@[@0.1,@0.5,@1]];
    gradientLayer2.frame = CGRectMake(self.frame.size.width/2 + 1.5, 0, self.frame.size.width/2 - 1.5, self.frame.size.height);
    [gradientLayer2 setColors:[NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0xfd/255.0 green:0xe8/255.0 blue:0x02/255.0 alpha:1.0] CGColor],(id)[MAIN_BLUE CGColor], nil]];
    [gradientLayer2 setStartPoint:CGPointMake(0.5, 0)];
    [gradientLayer2 setEndPoint:CGPointMake(0.5, 1)];
    [gradientLayer addSublayer:gradientLayer2];

    [gradientLayer setMask:self.progressLayer]; //用progressLayer来截取渐变层
    [self.layer addSublayer:gradientLayer];
}

- (void)setAnimationSpeed:(GPGrowStyle)style{
    self.growStyle = style;
}

/**
 *  设置进度条百分比
 *
 *  @param percent 百分百的值0-100之间的数值
 */
- (void)setPercent:(CGFloat)percent
{
    _process = percent;
    NSTimeInterval intervalTime = 0;
    currentPercent = 0;
    stepAddCount = 0.05;
    switch (self.growStyle) {
        case GrowStyleNone: {
            intervalTime = 0;
            break;
        }
        case GrowStyleLow: {
            intervalTime = 0.12;
            stepAddCount = 3;
            break;
        }
        case GrowStyleNormal: {
            intervalTime = 0.07;
            stepAddCount = 5;
            break;
        }
        case GrowStyleFast: {
            intervalTime = 0.02;
            stepAddCount = 11;
            break;
        }
        default:
            break;
    }
    if (intervalTime > 0) {
        self.gradTimer = [NSTimer scheduledTimerWithTimeInterval:intervalTime target:self selector:@selector(changeCirclePercent:) userInfo:nil repeats:YES];
    }
    else if (intervalTime == 0) {
        self.progressLayer.strokeEnd = percent/100.0;
    }
}

/**
 *  定时执行函数
 *
 *  @param timer timer对象
 */
-(void)changeCirclePercent:(NSTimer *)timer{
    if (currentPercent <= self.process) {
        self.progressLayer.strokeEnd = currentPercent/100.0;
        currentPercent += stepAddCount;
    }
    else {
        if (self.gradTimer && [self.gradTimer isValid]) {
            [self.gradTimer invalidate];
            self.gradTimer = nil;
        }
    }
}

/**
 *  创建圆型图形
 *
 *  @param position 中心点
 *  @param rect     创建区域
 *  @param radius   半径
 *
 *  @return 创建后的图形
 */
- (CAShapeLayer *)createCircleShapeWithPosition:(CGPoint)position pathRect:(CGRect)rect radius:(CGFloat)radius
{
    CAShapeLayer *circleShape = [CAShapeLayer layer];
    circleShape.path = [self createCirclePathWithRadius:rect radius:radius];
    circleShape.position = position;
    circleShape.fillColor = [UIColor clearColor].CGColor;
    circleShape.strokeColor = self.strokeColor ? self.strokeColor.CGColor : [UIColor purpleColor].CGColor;
    circleShape.opacity = 1;
    circleShape.lineWidth = 1;
    return circleShape;
}

/**
 *  创建圆形路径
 *
 *  @param frame  创建路径区域
 *  @param radius 创建区域的半径
 *
 *  @return 创建后圆形的路径
 */
- (CGPathRef)createCirclePathWithRadius:(CGRect)frame radius:(CGFloat)radius
{
    return [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:radius].CGPath;
}

/**
 *  创建贝塞尔曲线路径
 *
 *  @param radius     半径
 *  @param startAngle 开始的角度 范围为(-360度到360度)
 *  @param endAngle   终止的角度 范围为(-360度到360度)
 *
 *  @return 创建完成的贝塞尔曲线路径
 */
- (UIBezierPath *)createCirclePathWithRadius:(CGFloat)radius centerPoint:(CGPoint)centerPoint startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle {
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:centerPoint radius:radius startAngle:degreesToRadians(startAngle) endAngle:degreesToRadians(endAngle) clockwise:YES]; // (PROGREESS_WIDTH-PROGRESS_LINE_WIDTH)/2
    return path;
}

#pragma mark - Getter and Setter
/**
 *  0%时背景环
 *
 *  @return 背景环
 */
- (CAShapeLayer *)trackLayer{
    if (!_trackLayer) {
        _trackLayer = [CAShapeLayer layer];//创建一个track shape layer
        _trackLayer.frame = self.bounds;
        [self.layer addSublayer:_trackLayer];
        _trackLayer.fillColor = [[UIColor clearColor] CGColor];
        _trackLayer.strokeColor = [_strokeColor CGColor];//指定path的渲染颜色
        _trackLayer.opacity = 0.25; //背景同学你就甘心做背景吧，不要太明显了，透明度小一点
        _trackLayer.lineCap = kCALineCapRound;//指定线的边缘是圆的
        _trackLayer.lineWidth = PROGRESS_LINE_WIDTH;//线的宽度
        CGPoint circleCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)); //CGPointMake(40, 40)
        CGFloat diameterLen = CGRectGetWidth(self.bounds);
        if (self.startAngle == 0 && self.endAngle == 0) {
            self.startAngle = -270;
            self.endAngle = 90;
        }
        UIBezierPath *path = [self createCirclePathWithRadius:(diameterLen-PROGRESS_LINE_WIDTH)/2 centerPoint:circleCenter startAngle:self.startAngle endAngle:self.endAngle];//[UIBezierPath bezierPathWithArcCenter:circleCenter radius:(diameterLen-PROGRESS_LINE_WIDTH)/2 startAngle:degreesToRadians(-270) endAngle:degreesToRadians(90) clockwise:YES];//上面说明过了用来构建圆形
        _trackLayer.path =[path CGPath]; //把path传递給layer，然后layer会处理相应的渲染，整个逻辑和CoreGraph是一致的。
    }
    return _trackLayer;
}

/**
 *  进度环
 *
 *  @return 进度环
 */
- (CAShapeLayer *)progressLayer{
    if (!_progressLayer) {
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.frame = self.bounds;
        _progressLayer.fillColor =  [[UIColor clearColor] CGColor];
        _progressLayer.strokeColor  = [[UIColor whiteColor] CGColor];
        _progressLayer.lineCap = kCALineCapRound;
        _progressLayer.lineWidth = PROGRESS_LINE_WIDTH;
        //创建出圆形贝塞尔曲线
        CGPoint circleCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)); //CGPointMake(40, 40)
        CGFloat diameterLen = CGRectGetWidth(self.bounds);
        if (self.startAngle == 0 && self.endAngle == 0) {
            self.startAngle = -270;
            self.endAngle = 90;
        }
        UIBezierPath *path = [self createCirclePathWithRadius:(diameterLen-PROGRESS_LINE_WIDTH)/2 centerPoint:circleCenter startAngle:self.startAngle endAngle:self.endAngle];
        //UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:circleCenter radius:(diameterLen-PROGRESS_LINE_WIDTH)/2 startAngle:degreesToRadians(-270) endAngle:degreesToRadians(90) clockwise:YES];
        _progressLayer.path = [path CGPath];
        _progressLayer.strokeEnd = 0;
    }
    return _progressLayer;
}

/**
 *  进度条百分百
 *
 *  @return 进度条百分百
 */
- (CGFloat)percent {
    return _process;
}

/**
 *  设置渐变颜色组
 *
 *  @param colors UIColor对象数组, 每个对象类型需要为UIColor 否则无效
 */
- (void)setColorArr:(NSArray *)colors {
    _colorArr = [NSArray arrayWithArray:colors];
    if (self.colorArr != nil) {
        if ([self.colorArr count] == 1) {
            id mainColor = self.colorArr[0];
            if ([mainColor isKindOfClass:[UIColor class]]) {
                [gradientLayer1 setColors:[NSArray arrayWithObjects:(id)[mainColor CGColor],(id)[mainColor CGColor], nil]];
                [gradientLayer2 setColors:[NSArray arrayWithObjects:(id)[mainColor CGColor],(id)[mainColor CGColor], nil]];
            }
            
            
        }
        else if ([self.colorArr count] == 2) {
            UIColor *startColor = self.colorArr[0];
            UIColor *endColor = self.colorArr[1];
            const CGFloat *startComponents = CGColorGetComponents([startColor CGColor]);
            const CGFloat *endComponents = CGColorGetComponents([endColor CGColor]);
            CGFloat redValue = (startComponents[0] + endComponents[0]) / 2;
            CGFloat greenValue = (startComponents[1] + endComponents[1]) / 2;
            CGFloat blueValue = (startComponents[2] + endComponents[2]) / 2;
            CGFloat alphaValue = (startComponents[3] + endComponents[3]) / 2;
            UIColor *midColor = [UIColor colorWithRed:redValue green:greenValue blue:blueValue alpha:alphaValue];
            if ([startColor isKindOfClass:[UIColor class]] && [endColor isKindOfClass:[UIColor class]]) {
                [gradientLayer1 setColors:[NSArray arrayWithObjects:(id)[startColor CGColor],(id)[midColor CGColor], nil]];
                [gradientLayer2 setColors:[NSArray arrayWithObjects:(id)[midColor CGColor],(id)[endColor CGColor], nil]];
            }
        }
        else if ([self.colorArr count] >= 3) {
            UIColor *startColor = self.colorArr[0];
            UIColor *endColor = self.colorArr[2];
            UIColor *midColor = self.colorArr[1];
            if ([startColor isKindOfClass:[UIColor class]] && [endColor isKindOfClass:[UIColor class]] && [midColor isKindOfClass:[UIColor class]]) {
                [gradientLayer1 setColors:[NSArray arrayWithObjects:(id)[startColor CGColor],(id)[midColor CGColor], nil]];
                [gradientLayer2 setColors:[NSArray arrayWithObjects:(id)[midColor CGColor],(id)[endColor CGColor], nil]];
            }
        }
    }
}


@end
