//
//  ViewController.m
//  Crash异常捕获
//
//  Created by zhifu360 on 2019/9/25.
//  Copyright © 2019 ZZJ. All rights reserved.
//

#import "ViewController.h"

typedef NS_ENUM(NSUInteger, ViewControllerClickTag) {
    SignalExceptionTag = 0,
    OCExceptionTag
};

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat btnW = self.view.bounds.size.width / 2;
    CGFloat btnH = 100;
    for (int i = 0; i < 2; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(i*btnW, 200, btnW, btnH);
        btn.tag = i;
        [btn setTitle:i == 0 ? @"SignalException" : @"OCException" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
}

- (void)btnClick:(UIButton *)btn {
    if (btn.tag == SignalExceptionTag) {
        
    } else if (btn.tag == OCExceptionTag) {
        //iOS崩溃
        NSArray *array = @[@"Lucy",@"John",@"Luke"];
        [array objectAtIndex:5];
    }
}

@end
