//
//  confirmPasswordController.m
//  SuZhouProject
//  ************密码重置**************
//  Created by teddy on 15/10/9.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "confirmPasswordController.h"
#import "PasswordCell.h"

@interface confirmPasswordController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *passTable;
@property (weak, nonatomic) IBOutlet UIButton *confirm_btn;

//确定
- (IBAction)confirmPassAction:(id)sender;

//点击背景
- (IBAction)tapBackgroundAction:(id)sender;
@end

@implementation confirmPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.passTable.delegate = self;
    self.passTable.dataSource = self;
    self.passTable.scrollEnabled = NO;
    
    self.confirm_btn.layer.cornerRadius = 5.0;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        if ([self.passTable respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.passTable setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
    }
#endif
    
    if ([self.passTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.passTable setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PasswordCell *cell = (PasswordCell *)[[[NSBundle mainBundle] loadNibNamed:@"PasswordCell" owner:nil options:nil] lastObject];
    switch (indexPath.row) {
        case 0:
        {
            cell.positionLabel.text = @"新密码";
            cell.valueTextField.tag = 101;
        }
            break;
        case 1:
        {
            cell.positionLabel.text = @"再次输入";
            cell.valueTextField.tag = 102;
        }
            break;
        default:
            break;
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

    UIView *header = [[UIView alloc] initWithFrame:(CGRect){0,0,kScreenWidth,20}];
    return header;
}

//确定
- (IBAction)confirmPassAction:(id)sender
{

}

//点击背景取消键盘
- (IBAction)tapBackgroundAction:(id)sender
{
    UITextField *first = (UITextField *)[self.view viewWithTag:101];
    UITextField *second = (UITextField *)[self.view viewWithTag:102];
    [first resignFirstResponder];
    [second resignFirstResponder];
}
@end
