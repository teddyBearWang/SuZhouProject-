//
//  CustomTabBarController.m
//  SuZhouProject
//
//  Created by teddy on 15/9/29.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "CustomTabBarController.h"

@interface CustomTabBarController ()<UITabBarControllerDelegate>

@end

@implementation CustomTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationController.navigationBar setHidden:NO];
    
    self.delegate = self;
    self.title = @"消息";
    //构造方法生成UITabBarItem
    UITabBarItem *item1 = [self.tabBar.items objectAtIndex:0];
    item1.title = @"消息";
   // item1.selectedImage = ;
    //item1.image = ;
    
    //构造方法生成UITabBarItem
    UITabBarItem *item2 = [self.tabBar.items objectAtIndex:1];
    item2.title = @"任务";
    // item2.selectedImage = ;
    //item2.image = ;
    
    //构造方法生成UITabBarItem
    UITabBarItem *item3 = [self.tabBar.items objectAtIndex:2];
    item3.title = @"资料";
    // item3.selectedImage = ;
    //item3.image = ;
    
    //构造方法生成UITabBarItem
    UITabBarItem *item4= [self.tabBar.items objectAtIndex:3];
    item4.title = @"我的";
    // item4.selectedImage = ;
    //item4.image = ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITabBarController
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    switch (tabBarController.selectedIndex) {
        case 0:
        {
            self.title = @"消息";
        }
            break;
        case 1:
        {
            self.title = @"巡查任务";
        }
            break;
        case 2:
        {
            self.title = @"资料";
        }
            break;
        case 3:
        {
            self.title = @"我的";
        }
            break;
        default:
            break;
    }
}

@end
