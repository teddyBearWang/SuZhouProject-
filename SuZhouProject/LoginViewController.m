//
//  LoginViewController.m
//  SuZhouProject
//
//  Created by teddy on 15/9/29.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView; //顶部背景图片
@property (weak, nonatomic) IBOutlet UILabel *titleLabel; //标题
@property (weak, nonatomic) IBOutlet UITextField *userTextFiled; //用户名
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField; //密码
@property (weak, nonatomic) IBOutlet UIButton *login_btn; //登录按钮
//登录操作
- (IBAction)loginAction:(id)sender;

//点击背景取消键盘
- (IBAction)tapBackgroundAction:(id)sender;

@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.login_btn.layer.cornerRadius = 8.0f;
    [self.login_btn setBackgroundColor:[UIColor colorWithRed:49/255.0 green:65/255.0 blue:96/255.0 alpha:1.0]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//登录
- (IBAction)loginAction:(id)sender
{
    [self performSegueWithIdentifier:@"Login" sender:nil];
}

//点击背景取消键盘
- (IBAction)tapBackgroundAction:(id)sender
{
    [self.userTextFiled resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}
@end
