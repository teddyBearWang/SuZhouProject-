//
//  EditPswController.m
//  SuZhouProject
//  *********密码修改********
//  Created by teddy on 15/11/3.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "EditPswController.h"

@interface EditPswController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *oldPswField;
@property (weak, nonatomic) IBOutlet UITextField *aNewPswField;
@property (weak, nonatomic) IBOutlet UITextField *confirmField;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

- (IBAction)confirmAction:(id)sender;

- (IBAction)tapBackgroundAction:(id)sender;
@end

@implementation EditPswController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.confirmButton.layer.cornerRadius = 5;
    self.aNewPswField.secureTextEntry = YES;
    self.confirmField.secureTextEntry = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (IBAction)tapBackgroundAction:(id)sender
{
    [self.oldPswField resignFirstResponder];
    [self.aNewPswField resignFirstResponder];
    [self.confirmField resignFirstResponder];
}

- (IBAction)confirmAction:(id)sender
{
    if (self.oldPswField.text.length == 0 || self.aNewPswField.text.length == 0 || self.confirmField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"输入框不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (![self.aNewPswField.text isEqualToString:self.confirmField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"两次输入的新密码不一致，请检查后重新输入" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [self updatePSWAction];
}

//修改密码
- (void)updatePSWAction
{
    NSUserDefaults *users = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDict = [users objectForKey:@"UserInfo"];
    [SVProgressHUD showWithStatus:nil];
    NSString *results = [NSString stringWithFormat:@"%@$%@$%@",[userDict objectForKey:@"loginid"],self.oldPswField.text,self.aNewPswField.text];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [RequestHttps fetchWithType:@"UpdatePsw" Results:results completion:^(NSArray *datas) {
            //成功
            if (datas.count == 0) {
                [SVProgressHUD dismissWithError:@"修改密码失败"];
                return;
            }
            NSDictionary *dict = datas[0];
            if ([[dict objectForKey:@"success"] isEqualToString:@"True"]) {
                [SVProgressHUD dismissWithSuccess:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [SVProgressHUD dismissWithError:@"修改密码失败"];
            }
            
        } error:^(NSError *error) {
            //失败
            [SVProgressHUD dismissWithError:@"修改密码失败"];
        }];
    });

}
@end
