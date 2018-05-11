//
//  ViewController.m
//  HLBarrageDemo
//
//  Created by LHL on 2018/5/10.
//  Copyright © 2018 HL. All rights reserved.
//

#import "ViewController.h"
#import "HLBarrageManager.h"

@interface ViewController ()

@property (nonatomic, strong) HLBarrageManager *manager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.manager = [[HLBarrageManager alloc] init];
    __weak typeof(self) myself = self;
    self.manager.generateViewBlock = ^(HLBarrageView *view) {
        [myself addBarrageView:view];
    };
    
    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [startButton setTitle:@"Start" forState:UIControlStateNormal];
    [startButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    startButton.frame = CGRectMake(100, 50, 100, 40);
    [startButton addTarget:self  action:@selector(startClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startButton];
    
    UIButton *stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [stopButton setTitle:@"Stop" forState:UIControlStateNormal];
    [stopButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    stopButton.frame = CGRectMake(200, 50, 100, 40);
    [stopButton addTarget:self  action:@selector(stopClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopButton];

}

- (void)startClicked:(UIButton *)sender{
    for (NSInteger i = 0; i < 100 ; i++) {
        NSString *text = [NSString stringWithFormat:@"弹幕%@~~~~", @(i)];
        [self.manager.datasource addObject:text];
    }
    [self.manager start];
}

- (void)stopClicked:(UIButton *)sender{
    [self.manager stop];
}

- (void)addBarrageView:(HLBarrageView *)view{
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
    view.frame = CGRectMake(width, 80+view.trajectory*40, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds));
    [self.view addSubview:view];
    
    [view startAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
