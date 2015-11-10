//
//  FirstViewController.m
//  SuZhouProject
//  **********消息**************
//  Created by teddy on 15/9/29.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "FirstViewController.h"
#import "MessageCell.h"


@interface FirstViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_infoDataList; //数据源
    
    NSDictionary *_passDict;//传递的dict
}
@property (weak, nonatomic) IBOutlet UITableView *messageTable;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"消息";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getWebData];
}

#pragma mark - HTTP
//获取消息列表
- (void)getWebData
{
    NSUserDefaults *users = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDict = [users objectForKey:@"UserInfo"];
    [SVProgressHUD showWithStatus:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [RequestHttps fetchWithType:@"GetMessageList" Results:[userDict objectForKey:@"loginid"] completion:^(NSArray *datas) {
            //成功
            if (datas.count == 0) {
                [SVProgressHUD dismissWithError:@"数据为空"];
                return;
            }
            [SVProgressHUD dismissWithSuccess:nil];
            if (_infoDataList == nil) {
                _infoDataList = [NSMutableArray array];
            }
            else if (_infoDataList.count != 0)
            {
                [_infoDataList removeAllObjects];
            }
            for (NSDictionary *dict in datas) {
                [_infoDataList addObject:dict];
            }
            int num = [self NotReadMessage:_infoDataList];
            if (num > 0) {
                //设置标注
                self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",num];
            }else{
                self.tabBarItem.badgeValue  = nil;
            }
            [self.messageTable reloadData];
        } error:^(NSError *error) {
            //失败
            [SVProgressHUD dismissWithError:@"加载数据失败"];
        }];
    });
}

//得到没有阅读的消息数量
- (int)NotReadMessage:(NSMutableArray *)list
{
    int kCount = 0;
    for (NSDictionary *dict in list) {
        NSString *state = [dict objectForKey:@"flg"];
        if ([state hasPrefix:@"0"]) {
            //未读
            kCount++;
        }
    }
    return kCount;
}

#pragma amark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     return _infoDataList.count;
   // return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageCell *InfoCell = (MessageCell *)[[[NSBundle mainBundle] loadNibNamed:@"MessageCell" owner:nil options:nil] lastObject];
    NSDictionary *dict = _infoDataList[indexPath.row];
    [InfoCell updateCellUI:dict];
    InfoCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return InfoCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
    [self getMessageContent:[_infoDataList[indexPath.row] objectForKey:@"id"]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //删除信息
        NSString *messageId = [_infoDataList[indexPath.row] objectForKey:@"id"];
        [self deleteMessage:messageId indexPath:indexPath];
    }
}

//删除信息
- (void)deleteMessage:(NSString *)messageId indexPath:(NSIndexPath *)indexPath
{
    [SVProgressHUD showWithStatus:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [RequestHttps fetchWithType:@"DelMessage" Results:messageId completion:^(NSArray *datas) {
            //成功
            if (datas.count == 0) {
                [SVProgressHUD dismissWithError:@"删除失败"];
                return;
            }
            if ([[datas[0] objectForKey:@"success"] isEqualToString:@"True"]) {
                [SVProgressHUD dismissWithSuccess:nil];
                [_infoDataList removeObjectAtIndex:indexPath.row];
                // Delete the row from the data source.
                [self.messageTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self.messageTable reloadData];
            }else{
                [SVProgressHUD dismissWithError:@"删除失败"];
            }
        } error:^(NSError *error) {
            //失败
            [SVProgressHUD dismissWithError:@"删除失败"];
        }];
    });
}


- (void)getMessageContent:(NSString *)messageId
{
//    NSUserDefaults *users = [NSUserDefaults standardUserDefaults];
//    NSDictionary *userDict = [users objectForKey:@"UserInfo"];
    [SVProgressHUD showWithStatus:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [RequestHttps fetchWithType:@"GetMessageInfo" Results:messageId completion:^(NSArray *datas) {
            //成功
            if (datas.count == 0) {
                [SVProgressHUD dismissWithError:@"查看失败"];
                return;
            }else{
                [SVProgressHUD dismissWithSuccess:nil];
                _passDict = datas[0];
                //push到下一个界面
                [self performSegueWithIdentifier:@"messageDetail" sender:nil];
            }
        } error:^(NSError *error) {
            //失败
            [SVProgressHUD dismissWithError:@"查看失败"];
        }];
    });
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    id theSegue = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"messageDetail"]) {
        [theSegue setValue:_passDict forKey:@"passParameter"];
    }
}


@end
