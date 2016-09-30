//
//  YBRadarView.h
//  RadarDemo
//
//  Created by ChenWenHan on 16/9/29.
//  Copyright © 2016年 吴凯锋 QQ:24272779. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    YBRadarViewStyleDefault,
    YBRadarViewStyleLine,
} YBRadarViewStyle;

@interface YBRadarView : UIView

@property (nonatomic, assign) YBRadarViewStyle style;


-(instancetype)initWithFrame:(CGRect)frame avatar:(NSString *)avatar;

//继续
-(void)resume;

//取消
-(void)dismiss;

@end
