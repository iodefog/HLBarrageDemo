//
//  HLBarrageView.m
//  HLBarrageDemo
//
//  Created by LHL on 2018/5/10.
//  Copyright © 2018 HL. All rights reserved.
//  https://www.imooc.com/video/12256
//

#import "HLBarrageView.h"

#define Padding 10

@interface HLBarrageView ()

@property (nonatomic, strong) UIView  *contentView;
@property (nonatomic, strong) UILabel *barrageLabel;

@end

@implementation HLBarrageView

// 初始化弹幕
- (instancetype)initWithContent:(NSString *)content{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.contentView];
        
        [self addSubview:self.barrageLabel];
        self.barrageLabel.text = content;
        
        NSDictionary *attr = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        CGFloat width = [content sizeWithAttributes:attr].width;
        self.bounds = CGRectMake(0, 0, width + 2 * Padding, 30);
        self.barrageLabel.frame = CGRectMake(Padding, 0, width, 30);
    }
    return self;
}

// 开始动画
- (void)startAnimation{
    
    // 根据弹幕长度执行动画效果
    // 根据 v = s/t, 时间相同情况下，距离
    
    
    CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat duration = 4.0f;
    CGFloat wholeWidth = screenWidth + CGRectGetWidth(self.bounds);

    if (self.moveStatusBlock) {
        self.moveStatusBlock(HLMoveStatus_Start);
    }

    // t = s/v;
    CGFloat speed = wholeWidth/duration;
    CGFloat enterDuration = CGRectGetWidth(self.bounds)/speed;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(enterScreen) object:nil];
    [self performSelector:@selector(enterScreen) withObject:nil afterDelay:enterDuration];
    
    
    
    __block CGRect frame = self.frame;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        frame.origin.x -= wholeWidth;
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.moveStatusBlock) {
            self.moveStatusBlock(HLMoveStatus_End);
        }
    }];
}

// 弹幕元素进入屏幕
- (void)enterScreen{
    if (self.moveStatusBlock) {
        self.moveStatusBlock(HLMoveStatus_Enter);
    }
}

// 停止动画
- (void)stopAnimation{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
    
}

- (UILabel *)barrageLabel{
    if (!_barrageLabel) {
        _barrageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _barrageLabel.font = [UIFont systemFontOfSize:14];
        _barrageLabel.textColor = [UIColor whiteColor];
        _barrageLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _barrageLabel;
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentView.backgroundColor = [UIColor redColor];
    }
    return _contentView;
}

@end
