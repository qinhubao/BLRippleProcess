//
//  ViewController.m
//  BLRippleProcess
//
//  Created by Bell Lake on 16/2/29.
//  Copyright © 2016年 Bell Lake. All rights reserved.
//

#import "ViewController.h"
#import "GradientProgress.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor darkGrayColor]];
    GradientProgress *gradView = [[GradientProgress alloc] initWithFrame:CGRectMake(150, 150, 100, 100)];
    [self.view addSubview:gradView];
    // 设置渐变颜色  如果没有渐变 只放一种颜色  最多3种
    NSArray *colors = [NSArray arrayWithObjects:[UIColor purpleColor], [UIColor yellowColor], nil];
    [gradView setColorArr:colors];
    [gradView setStrokeColor: [UIColor whiteColor]];    // 设置0%时候的颜色
    // 设置动画速度  GrowStyleNone  没有动画  GrowStyleNormal 正常速度增加  GrowStyleFast  快速增加
    [gradView setAnimationSpeed:GrowStyleLow];
    [gradView setPercent:80];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
