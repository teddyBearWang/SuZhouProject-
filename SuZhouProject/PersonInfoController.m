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
    NSArray *_questionList;//数据源问题验证
    NSDictionary *_sourceDictionary;//源数据
    
    NSDictionary *_passDictionary;//传递到下一个界面的dict
}

//个人信息
@property (weak, nonatomic) IBOutlet UITableView *infoTableView;
@end

@implementation PersonInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //_infoList = @[@"所在部门",@"职务",@"手机",@"座机",@"地址"];
    
    [self getWebData];
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

//获取网络数据
- (void)getWebData
{
    
    NSUserDefaults *users = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDict = [users objectForKey:@"UserInfo"];
    [SVProgressHUD showWithStatus:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [RequestHttps fetchWithType:@"GetUserInfo" Results:[userDict objectForKey:@"loginid"] completion:^(NSArray *datas) {
            //成功
            if (datas.count == 0) {
                [SVProgressHUD dismissWithError:@"数据为空"];
                return;
            }
            [SVProgressHUD dismissWithSuccess:nil];
            _sourceDictionary = datas[0];
            _infoList = (NSArray *)[_sourceDictionary objectForKey:@"detailInfo"];
            _questionList = (NSArray *)[_sourceDictionary objectForKey:@"security"];
            [self.infoTableView reloadData];
        } error:^(NSError *error) {
            //失败
            [SVProgressHUD dismissWithError:@"加载数据失败"];
        }];
    });
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
            return _questionList.count;
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
            NSArray *NameInfo = (NSArray *)[_sourceDictionary objectForKey:@"infoName"];
            cell.postionLabel.text = [NameInfo[0] objectForKey:@"type_c"];
            cell.valueLabel.text = [NameInfo[0] objectForKey:@"value"];
        }
            break;
        case 1:
        {
            NSDictionary *dict = _infoList[indexPath.row];
            cell.postionLabel.text = [dict objectForKey:@"type_c"];
            cell.valueLabel.text = [dict objectForKey:@"value"];
        }
            break;
        case 2:
        {
            NSDictionary *dict = _questionList[indexPath.row];
            cell.postionLabel.text = [dict objectForKey:@"type_c"];
             cell.valueLabel.text = [dict objectForKey:@"value"];
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
        NSArray *NameInfo = (NSArray *)[_sourceDictionary objectForKey:@"infoName"];
        _passDictionary = NameInfo[0];
    }
    else if (indexPath.section == 1)
    {
        _passDictionary = _infoList[indexPath.row];
    }
    else if (indexPath.section == 2)
    {
        _passDictionary = _questionList[indexPath.row];
    }
    [self performSegueWithIdentifier:@"editInfo" sender:nil];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"editInfo"]) {
        id theSegue = segue.destinationViewController;
        [theSegue setValue:_passDictionary forKey:@"passDict"];
    }
}
@end
