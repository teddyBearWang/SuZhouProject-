//
//  ChangePasswordController.m
//  SuZhouProject
//  *************找回密码*************
//  Created by teddy on 15/9/29.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "ChangePasswordController.h"
#import "PasswordCell.h"

@interface ChangePasswordController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *confirm_btn; //确认按钮
@property (weak, nonatomic) IBOutlet UITableView *problemTable;//问题列表

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
    
    self.problemTable.delegate = self;
    self.problemTable.dataSource = self;
    self.problemTable.scrollEnabled = NO;
    
    self.confirm_btn.layer.cornerRadius = 5.0f;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        if ([self.problemTable respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.problemTable setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
    }
#endif
    
    if ([self.problemTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.problemTable setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//确认修改密码
- (IBAction)confirmPasswordAction:(id)sender
{
//    if ([self.passwordTextField.text isEqual:self.confirmTextField.text]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"两次输入的密码不一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//        return;
//    }
    [self performSegueWithIdentifier:@"confirmPassword" sender:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PasswordCell *cell = (PasswordCell *)[[[NSBundle mainBundle] loadNibNamed:@"PasswordCell" owner:nil options:nil] lastObject];
    if (indexPath.section == 0) {
        cell.positionLabel.text = @"用户名";
        cell.valueTextField.tag = 101;
    }else{
        switch (indexPath.row) {
            case 0:
            {
                cell.positionLabel.text = @"安全问题";
                cell.valueTextField.tag = 102;
            }
                break;
            case 1:
            {
                cell.positionLabel.text = @"问题答案";
                cell.valueTextField.tag = 103;
            }
                break;
            default:
                break;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
    }
#endif
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
   
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *header = [[UIView alloc] initWithFrame:(CGRect){0,0,kScreenWidth,1}];
        return header;
    }else{
        UIView *header = [[UIView alloc] initWithFrame:(CGRect){0,0,kScreenWidth,20}];
        return header;
    }
}

//点击背景取消键盘
- (IBAction)tapBackgroundAction:(id)sender
{
    UITextField *first = (UITextField *)[self.view viewWithTag:101];
    UITextField *second = (UITextField *)[self.view viewWithTag:102];
    UITextField *third = (UITextField *)[self.view viewWithTag:103];
    [first resignFirstResponder];
    [second resignFirstResponder];
    [third resignFirstResponder];
}



@end
