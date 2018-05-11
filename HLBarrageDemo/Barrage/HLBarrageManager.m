//
//  HLBarrageManager.m
//  HLBarrageDemo
//
//  Created by LHL on 2018/5/10.
//  Copyright © 2018 HL. All rights reserved.
//  https://www.imooc.com/video/12256
//

#import "HLBarrageManager.h"

#define MaxTrajectorys 18 // 最大弹道数

@interface HLBarrageManager()

// 弹幕使用过程中的数组变量
@property (nonatomic, strong) NSMutableArray *barrageArray;

// 存储弹幕view的数组变量
@property (nonatomic, strong) NSMutableArray *barrageViews;

@property (nonatomic, assign) BOOL isStopAnimaiton;


@end

@implementation HLBarrageManager

- (instancetype)init{
    if (self = [super init]) {
        self.isStopAnimaiton = YES;
    }
    return self;
}

- (void)start{
    if (!self.isStopAnimaiton || !self.datasource || (self.datasource.count == 0)) {
        return;
    }
    self.isStopAnimaiton = NO;
    
    [self.barrageArray removeAllObjects];
    [self.barrageArray addObjectsFromArray:self.datasource];
    
    [self initBarrageView];
}

// 初始化弹幕，随机分配弹道轨迹
- (void)initBarrageView{
    if (self.barrageArray.count == 0) {
        return;
    }
    
    NSMutableArray *trajectorys = [NSMutableArray array];
    for (NSInteger i = 0; i < MaxTrajectorys ; i ++) {
        [trajectorys addObject:@(i)];
    }
    
    for (NSInteger i = 0; i < MaxTrajectorys; i ++) {
        
        // 通过随机数获取到弹幕的轨迹
        NSInteger index = arc4random()%trajectorys.count;
        NSInteger trajectory = [[trajectorys objectAtIndex:index] integerValue];
        [trajectorys removeObjectAtIndex:index];
        
        // 从弹幕数组中逐一取出弹幕数据
        NSString *content = [self.barrageArray firstObject];
        [self.barrageArray removeObjectAtIndex:0];
        
        // 创建弹幕view
        [self createBarrageView:content trajectory:trajectory];
    }
}

- (void)createBarrageView:(NSString *)content trajectory:(NSInteger)trajectory{
    
    HLBarrageView *view = [[HLBarrageView alloc] initWithContent:content];
    view.trajectory = trajectory;
    [self.barrageViews addObject:view];
    
    __weak typeof(view) weakView = view;
    __weak typeof(self) weakself = self;

    view.moveStatusBlock = ^(HLMoveStatus status){
        if (weakself.isStopAnimaiton) {
            return ;
        }
        switch (status) {
            case HLMoveStatus_Start:
            {
                // 弹幕开始进入屏幕，讲view加入弹幕管理的变量中barrageViews
                [weakself.barrageViews addObject:weakView];
                break;
            }
            case HLMoveStatus_Enter:
            {
                // 弹幕完全进入屏幕，判断是否还有其他内容，如果有，则再该弹幕轨迹中创建一个
                NSString *content = [weakself nextBarrageContent];
                if (content) {
                    [weakself createBarrageView:content trajectory:trajectory];
                }
                break;
            }
            case HLMoveStatus_End:
            {
             // 弹幕飞出屏幕后从数组中移除
                if ([weakself.barrageViews containsObject:weakView]) {
                    [weakView stopAnimation];
                    [weakself.barrageViews removeObject:weakView];
                }
                if(weakself.barrageViews.count == 0){
                    // 说明屏幕没有弹幕了。这里重新执行弹幕
                    weakself.isStopAnimaiton = YES;
                    [weakself start];
                }
                break;
            }
            default:
                break;
        }
    };
    
    if (self.generateViewBlock) {
        self.generateViewBlock(view);
    }
}

- (void)stop{
    if (self.isStopAnimaiton) {
        return;
    }
    self.isStopAnimaiton = YES;

    [self.barrageViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HLBarrageView *view = obj;
        [view stopAnimation];
        view = nil;
    }];
    [self.barrageViews removeAllObjects];
}

- (NSString *)nextBarrageContent{
    if (self.barrageArray.count == 0) {
        return nil;
    }
    
    NSString *content = [self.barrageArray firstObject];
    if (content) {
        [self.barrageArray removeObjectAtIndex:0];
    }
    return content;
}

#pragma mark -


- (NSMutableArray *)datasource{
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

- (NSMutableArray *)barrageArray{
    if (!_barrageArray) {
        _barrageArray = [NSMutableArray array];
    }
    return _barrageArray;
}

- (NSMutableArray *)barrageViews{
    if (!_barrageViews) {
        _barrageViews = [NSMutableArray array];
    }
    return _barrageViews;
}

@end
