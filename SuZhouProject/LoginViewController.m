//
//  LoginViewController.m
//  SuZhouProject
//
//  Created by teddy on 15/9/29.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "LoginViewController.h"
#import "RequestHttps.h"
#import "SVProgressHUD.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView; //顶部背景图片
@property (weak, nonatomic) IBOutlet UITextField *userTextFiled; //用户名
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField; //密码
@property (weak, nonatomic) IBOutlet UIButton *login_btn; //登录按钮
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UIImageView *passwordImageView;


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
    self.userImageView.image = [UIImage imageNamed:@"user"];
    self.passwordTextField.secureTextEntry = YES;
    self.passwordImageView.image = [UIImage imageNamed:@"password"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//登录
- (IBAction)loginAction:(id)sender
{
    if (self.userTextFiled.text.length == 0 || self.passwordTextField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"用户名或密码不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    NSString *result = [NSString stringWithFormat:@"%@$%@",self.userTextFiled.text,self.passwordTextField.text];
    [self requestWebAction:result];
   
}

//网络验证
- (void)requestWebAction:(NSString *)valueString
{
    [SVProgressHUD showWithStatus:@"登录中..."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([RequestHttps fetchWithType:@"Login" Results:valueString]) {
            [self updateUI];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismissWithError:@"登录失败"];
            });
        }
    });
}

- (void)updateUI
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *requestData = [RequestHttps requrstJsonData];
        if (requestData.count != 0) {
            [SVProgressHUD dismissWithSuccess:@"登陆成功"];
            //登陆成功
            [self performSegueWithIdentifier:@"Login" sender:nil];
            //将个人信息保存在本地
            [self saveInfo:requestData[0]];
        }else{
            [SVProgressHUD dismissWithError:@"登录失败"];
        }
    });
}

//将登陆信息保存在本地
- (void)saveInfo:(NSDictionary *)info
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:info forKey:@"UserInfo"];
    [userDefaults synchronize];
}

//点击背景取消键盘
- (IBAction)tapBackgroundAction:(id)sender
{
    [self.userTextFiled resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}
@end
