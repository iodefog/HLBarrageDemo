//
//  HLBarrageView.h
//  HLBarrageDemo
//
//  Created by LHL on 2018/5/10.
//  Copyright © 2018 HL. All rights reserved.
//  https://www.imooc.com/video/12256
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    HLMoveStatus_Start,
    HLMoveStatus_Enter,
    HLMoveStatus_End
} HLMoveStatus;

@interface HLBarrageView : UIView

@property (nonatomic, assign) NSInteger trajectory; // 弹道
@property (nonatomic, copy) void(^moveStatusBlock)(HLMoveStatus status); // 弹道状态回调

// 初始化弹幕
- (instancetype)initWithContent:(NSString *)content;

// 开始动画
- (void)startAnimation;

// 停止动画
- (void)stopAnimation;

@end
