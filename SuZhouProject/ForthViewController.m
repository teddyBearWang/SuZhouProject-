//
//  ForthViewController.m
//  SuZhouProject
//  ************我的*************
//  Created by teddy on 15/9/30.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "ForthViewController.h"

@interface ForthViewController ()<UITableViewDataSource,UITableViewDelegate>
//背景图片
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

//头像图片
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
//名字标签
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
//详细列表
@property (weak, nonatomic) IBOutlet UITableView *detaiTable;
@end

@implementation ForthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.userImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.userImageView.layer.borderWidth = 2.0;
    self.userImageView.layer.cornerRadius = 30;
    self.userImageView.clipsToBounds = YES;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSUserDefaults *users = [NSUserDefaults standardUserDefaults];
    NSDictionary *uerDict = [users objectForKey:@"UserInfo"];
    self.userNameLabel.text = [uerDict objectForKey:@"username"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        if ([self.detaiTable respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.detaiTable setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
    }
#endif
    
    if ([self.detaiTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.detaiTable setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
}

#pragma amark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     //return 3;
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    switch (indexPath.row) {
        case 0:
        {
            //个人信息
            cell.textLabel.text = @"个人信息";
            cell.imageView.image = [UIImage imageNamed:@"userInfo"];
        }
            break;
        case 1:
        {
            //密码修改
            cell.textLabel.text = @"密码修改";
            cell.imageView.image = [UIImage imageNamed:@"passChange"];
        }
            break;
//        case 2:
//        {
//            //任务委托
//            cell.textLabel.text = @"任务委托";
//            cell.imageView.image = [UIImage imageNamed:@"delegateImage"];
//        }
//            break;
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,kScreenWidth,1}];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            //个人信息
            [self performSegueWithIdentifier:@"personInfoDetail" sender:nil];
        }
            break;
        case 1:
        {
            //密码修改
            [self performSegueWithIdentifier:@"eidtPassword" sender:nil];
        }
            break;
//        case 2:
//        {
//            //任务委托
//            [self performSegueWithIdentifier:@"delegateTask" sender:nil];
//        }
//            break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"personInfoDetail"]) {
        //id theSegue = segue.destinationViewController;
        //个人信息
    }
}

@end
