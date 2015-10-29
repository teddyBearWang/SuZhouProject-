//
//  SecondViewController.m
//  SuZhouProject
//  ************任务************
//  Created by teddy on 15/9/29.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "SecondViewController.h"
#import "TaskCell.h"
#import "RequestHttps.h"
#import "SVProgressHUD.h"

@interface SecondViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_taskList;//任务数据源
    NSString *_selectId;//选择任务的id;
}
@property (weak, nonatomic) IBOutlet UITableView *taskTableView;

@end

@implementation SecondViewController

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    if ([self.taskTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.taskTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        if ([self.taskTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.taskTableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
    }
    
#endif
}

//切换界面的时候
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //取消网络请求
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        [RequestHttps cancelRequest];
        [SVProgressHUD dismiss];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSDictionary *info = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"];
    //加载网络数据
    [self getRequestJsonData:[info objectForKey:@"loginid"]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"任务";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getWebData
- (void)getRequestJsonData:(NSString *)results
{
    [SVProgressHUD showWithStatus:@"加载中"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([RequestHttps fetchWithType:@"GetTask" Results:results]) {
            [self updateUI];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismissWithError:@"加载失败"];
            });
        }
    });
}

- (void)updateUI
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSArray *list = [RequestHttps requrstJsonData];
        if (list.count != 0) {
            [SVProgressHUD dismissWithSuccess:@"加载成功"];
            _taskList = list;
            int num = [self NotPartrolTask:_taskList];
            if (num > 0) {
                //设置标注
                self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",num];
            }else{
                self.tabBarItem.badgeValue  = nil;
            }
          
            [self.taskTableView reloadData];
        }else{
            [SVProgressHUD dismissWithError:@"数据为空"];
        }
    });
}

//得到没有巡查的任务数量
- (int)NotPartrolTask:(NSArray *)list
{
    int kCount = 0;
    for (NSDictionary *dict in list) {
       NSString *state = [dict objectForKey:@"state"];
        if ([state hasPrefix:@"未巡查"]) {
            kCount++;
        }
    }
    return kCount;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _taskList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"taskCell";
    TaskCell *cell = (TaskCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = (TaskCell *)[[[NSBundle mainBundle] loadNibNamed:@"TaskCell" owner:nil options:nil] lastObject];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary *dict = _taskList[indexPath.row];
    [cell updateCellUI:dict];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

/*
 *去掉tableView group样式下，距离顶部有44pix像素的距离
 */

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc] initWithFrame:(CGRect){0,0,320,1}];
    sectionView.backgroundColor = [UIColor clearColor];
    return sectionView;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 8.0) {
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
    NSDictionary *dict = _taskList[indexPath.row];
    _selectId = [dict objectForKey:@"id"];
    [self performSegueWithIdentifier:@"voteDetail" sender:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"voteDetail"]) {
        id theSegue = segue.destinationViewController;
        [theSegue setValue:_selectId forKey:@"taskId"];
    }
}

@end
