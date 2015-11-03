//
//  PersonInfoController.m
//  SuZhouProject
//   *******个人信息*************
//  Created by teddy on 15/11/3.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "PersonInfoController.h"
#import "PersonInfoCell.h"

@interface PersonInfoController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_infoList;//数据源
    
    NSString *_selectKeyName;//传递到下一个界面的keyName
    NSString *_selectValueName;//传递到下一个界面的valueName
}

//个人信息
@property (weak, nonatomic) IBOutlet UITableView *infoTableView;
@end

@implementation PersonInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _infoList = @[@"所在部门",@"职务",@"手机",@"座机",@"地址"];
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
        if ([self.infoTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.infoTableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
    }
#endif
    
    if ([self.infoTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.infoTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
}

#pragma amark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return 1;
        }
            break;
        case 1:
        {
            return _infoList.count;
        }
            break;
        case 2:
        {
            return 2;
        }
            break;
        default:
        {
            return 0;
        }
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonInfoCell *cell = (PersonInfoCell *)[[[NSBundle mainBundle] loadNibNamed:@"PersonInfoCell" owner:nil options:nil] lastObject];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    switch (indexPath.section) {
        case 0:
        {
            cell.postionLabel.text = @"真实姓名";
            cell.valueLabel.text = @"郭建国";
        }
            break;
        case 1:
        {
            cell.postionLabel.text = _infoList[indexPath.row];
        }
            break;
        case 2:
        {
            cell.valueLabel.hidden = YES;
            if (indexPath.row == 0) {
               cell.postionLabel.text = @"安全问题";
            }else{
                cell.postionLabel.text = @"问题答案";
            }
        }
            break;
        default:
     
            break;
    }
    return cell;
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
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,kScreenWidth,20}];
    view.backgroundColor = BG_COLOR;
    return view;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        //编辑信息
        _selectKeyName = @"真实姓名";
        _selectValueName = @"郭建国";
    }
    else if (indexPath.section == 1)
    {
        _selectKeyName = _infoList[indexPath.row];
        _selectValueName = @"苏州市河道管理局";
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0) {
            _selectKeyName = @"安全问题";
            _selectValueName = @"";
        }else{
            _selectKeyName = @"问题答案";
            _selectValueName = @"";
        }
    }
    [self performSegueWithIdentifier:@"editInfo" sender:nil];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"editInfo"]) {
        id theSegue = segue.destinationViewController;
        [theSegue setValue:_selectKeyName forKey:@"passKey"];
        [theSegue setValue:_selectValueName forKey:@"passvalue"];
    }
}
@end
