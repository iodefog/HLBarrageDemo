//
//  HLBarrageManager.h
//  HLBarrageDemo
//
//  Created by LHL on 2018/5/10.
//  Copyright © 2018 HL. All rights reserved.
//  https://www.imooc.com/video/12256
//

#import <Foundation/Foundation.h>
#import "HLBarrageView.h"

@interface HLBarrageManager : NSObject

// 弹幕数据来源
@property (nonatomic, strong) NSMutableArray *datasource;


@property (nonatomic, copy) void(^generateViewBlock)(HLBarrageView *view);

// 弹幕开始执行
- (void)start;

// 弹幕停止
- (void)stop;

@end
