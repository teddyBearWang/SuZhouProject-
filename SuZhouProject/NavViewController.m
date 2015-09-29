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
    self.navigationBar.barTintColor = [UIColor colorWithRed:45/255.0 green:65/255.0 blue:96/255.0 alpha:1.0];
    self.navigationBar.translucent = NO;//不模糊
    
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
