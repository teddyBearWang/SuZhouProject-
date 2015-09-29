//
//  ChangePasswordController.m
//  SuZhouProject
//
//  Created by teddy on 15/9/29.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "ChangePasswordController.h"

@interface ChangePasswordController ()
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;//新密码
@property (weak, nonatomic) IBOutlet UITextField *confirmTextField; //确认密码
@property (weak, nonatomic) IBOutlet UIButton *confirm_btn; //确认按钮

//确认操作
- (IBAction)confirmPasswordAction:(id)sender;

//点击背景取消键盘
- (IBAction)tapBackgroundAction:(id)sender;
@end

@implementation ChangePasswordController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.confirm_btn.layer.cornerRadius = 8.0;
    [self.confirm_btn setBackgroundColor:[UIColor colorWithRed:49/255.0 green:65/255.0 blue:96/255.0 alpha:1.0]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//确认修改密码
- (IBAction)confirmPasswordAction:(id)sender
{
    
}

//点击背景取消键盘
- (IBAction)tapBackgroundAction:(id)sender
{
    [self.passwordTextField resignFirstResponder];
    [self.confirmTextField resignFirstResponder];
}
@end
