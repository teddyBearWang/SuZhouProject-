//
//  EditInfoController.m
//  SuZhouProject
//  ********信息编辑界面***********
//  Created by teddy on 15/11/3.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "EditInfoController.h"

@interface EditInfoController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *keyLabel;
@property (weak, nonatomic) IBOutlet UITextField *valueField;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

- (IBAction)confirmAction:(id)sender;

//点击背景
- (IBAction)tabBackground:(id)sender;
@end

@implementation EditInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.confirmButton.layer.cornerRadius = 6;
    self.valueField.delegate = self;
    
    self.title = [self.passDict objectForKey:@"type_c"];
    self.keyLabel.text = [self.passDict objectForKey:@"type_c"];
    
    self.valueField.placeholder = [self.passDict objectForKey:@"value"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        [self.valueField resignFirstResponder];
    }
    return YES;
}

//确认上传
- (IBAction)confirmAction:(id)sender
{
    if (self.valueField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"修改的内容不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [self updateInfoAction];
    
}

- (void)updateInfoAction
{
    NSUserDefaults *users = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDict = [users objectForKey:@"UserInfo"];
    [SVProgressHUD showWithStatus:nil];
    NSString *results = [NSString stringWithFormat:@"%@$%@$%@",[userDict objectForKey:@"loginid"],[self.passDict objectForKey:@"type_e"],self.valueField.text];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [RequestHttps fetchWithType:@"GetUserInfo" Results:results completion:^(NSArray *datas) {
            //成功
            if (datas.count == 0) {
                [SVProgressHUD dismissWithError:@"更新失败"];
                return;
            }
            NSDictionary *dict = datas[0];
            if ([[dict objectForKey:@"success"] isEqualToString:@"True"]) {
                [SVProgressHUD dismissWithSuccess:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [SVProgressHUD dismissWithError:@"更新失败"];
            }
            
        } error:^(NSError *error) {
            //失败
            [SVProgressHUD dismissWithError:@"更新失败"];
        }];
    });
}

//点击背景
- (IBAction)tabBackground:(id)sender
{
    [self.valueField resignFirstResponder];
}
@end
