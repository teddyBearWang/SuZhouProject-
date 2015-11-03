//
//  NavViewController.m
//  SuZhouProject
//
//  Created by teddy on 15/9/29.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "NavViewController.h"

@interface NavViewController ()

@end

@implementation NavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置返回按钮的颜色
    self.navigationBar.tintColor = [UIColor whiteColor];
    //设置navigationbar的背景颜色
    self.navigationBar.barTintColor = [UIColor colorWithRed:48/255.0 green:64/255.0 blue:97/255.0 alpha:1.0];
    self.navigationBar.translucent = NO;//不模糊
    
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:YES];
    if (self.viewControllers.count > 0) {
        self.hidesBottomBarWhenPushed = YES;
    }
}

@end
