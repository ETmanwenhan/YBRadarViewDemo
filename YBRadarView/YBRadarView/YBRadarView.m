//
//  YBRadarView.m
//  RadarDemo
//
//  Created by ChenWenHan on 16/9/29.
//  Copyright © 2016年 吴凯锋 QQ:24272779. All rights reserved.
//

#import "YBRadarView.h"

@interface YBRadarView ()

@property (nonatomic,weak) CALayer *animationLayer;
@property (nonatomic,strong) UIImage *avatarImage;

@end

@implementation YBRadarView

-(instancetype)initWithFrame:(CGRect)frame avatar:(NSString *)avatar
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        _style = YBRadarViewStyleDefault;
        self.avatarImage = [UIImage imageNamed:avatar];
        
        //监听当从后台进入前台，防止假死状态
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(resume)
                                                    name:UIApplicationDidBecomeActiveNotification object:nil];
        
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    [[UIColor clearColor]setFill];
    UIRectFill(rect);
    
    NSLog(@"^^^^");
    
    NSInteger pulsingCount = 3;
    CGFloat animationDuration = 2.0;
    
    CALayer * animationLayer = [[CALayer alloc]init];
    self.animationLayer = animationLayer;
    
    for (int i = 0; i < pulsingCount; i++) {
        
        CALayer * pulsingLayer = [[CALayer alloc]init];
        pulsingLayer.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
        pulsingLayer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor;
        pulsingLayer.cornerRadius = rect.size.height/2;
        pulsingLayer.borderWidth = 3.0;
        
        if (_style == YBRadarViewStyleDefault) {
            pulsingLayer.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor;
        }
        
        CAMediaTimingFunction * defaultCurve =
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        CAAnimationGroup * animationGroup = [[CAAnimationGroup alloc]init];
        animationGroup.fillMode = kCAFillModeBoth;
        animationGroup.beginTime = CACurrentMediaTime() + (double)i * animationDuration/(double)pulsingCount;
        animationGroup.duration = animationDuration;
        animationGroup.repeatCount = HUGE_VAL;
        animationGroup.timingFunction = defaultCurve;
        
        CABasicAnimation * scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.autoreverses = NO;
        scaleAnimation.fromValue    = @(0.2);
        scaleAnimation.toValue      = @(1.0);
        
        CAKeyframeAnimation * opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.values     = @[@(1.0),@(0.5),@(0.3),@(0.0)];
        opacityAnimation.keyTimes   = @[@(0.0),@(0.25),@(0.5),@(1.0)];
        animationGroup.animations   = @[scaleAnimation,opacityAnimation];
        
        [pulsingLayer addAnimation:animationGroup forKey:@"pulsing"];
        [animationLayer addSublayer:pulsingLayer];
    }
    self.animationLayer.zPosition = -1;//使动画至底层
    [self.layer addSublayer:self.animationLayer];
    
    //添加头像层
    CALayer * avatarLayer = [[CALayer alloc]init];
    CGRect avatarRect = CGRectMake(0, 0, 100, 100);
    avatarRect.origin.x = rect.size.width * 0.5 - avatarRect.size.width * 0.5;
    avatarRect.origin.y = rect.size.height * 0.5 - avatarRect.size.height * 0.5;
    avatarLayer.masksToBounds = YES;
    avatarLayer.frame = avatarRect;
    avatarLayer.cornerRadius = avatarRect.size.width/2;
    avatarLayer.contents = (id)self.avatarImage.CGImage;
    avatarLayer.zPosition = -1;
    [self.layer addSublayer:avatarLayer];
}

-(void)resume
{
    if (self.animationLayer)
        [self.animationLayer removeFromSuperlayer];
    
    [self setNeedsDisplay];
}

-(void)dismiss
{
    if (self.animationLayer) {
        [self.animationLayer removeFromSuperlayer];
    }
}

- (void)dealloc
{
    NSLog(@"销毁%s",__FUNCTION__);
}

@end
