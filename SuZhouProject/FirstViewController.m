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
    
    NSDictionary *_selectDict;//选择的dict
}
@property (weak, nonatomic) IBOutlet UITableView *messageTable;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"消息";
//    _infoDataList = [NSMutableArray arrayWithObjects:@"这是一个新的巡查内容，请你按时去完成巡查并登记上报",@"这是一个新的巡查内容，请你按时去完成巡查并登记上报",@"这是一个新的巡查内容，请你按时去完成巡查并登记上报",@"这是一个新的巡查内容，请你按时去完成巡查并登记上报", nil];
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
//获取网络数据
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
     
            [self.messageTable reloadData];
        } error:^(NSError *error) {
            //失败
            [SVProgressHUD dismissWithError:@"加载数据失败"];
        }];
    });
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
    return 100;
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
    _selectDict = _infoDataList[indexPath.row];
    [self performSegueWithIdentifier:@"messageDetail" sender:nil];
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
        [_infoDataList removeObjectAtIndex:indexPath.row];
        // Delete the row from the data source.
        [self.messageTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    id theSegue = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"messageDetail"]) {
        [theSegue setValue:@"选择行数" forKey:@"passParameter"];
    }
}


@end
