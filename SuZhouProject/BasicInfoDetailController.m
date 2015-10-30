//
//  BasicInfoDetailController.m
//  SuZhouProject
//  *************基础信息详情**************
//  Created by teddy on 15/10/30.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "BasicInfoDetailController.h"
#import "TaskDetail.h"
#import "BasicDetaifHeader.h"

@interface BasicInfoDetailController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_list;//数据源
}
//顶部视图
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
//详细列表
@property (weak, nonatomic) IBOutlet UITableView *detailTable;

@end

@implementation BasicInfoDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableVIewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return _list.count;
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     TaskDetail *cell = (TaskDetail *)[[[NSBundle mainBundle] loadNibNamed:@"TaskDetail" owner:nil options:nil] lastObject];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    BasicDetaifHeader *basicHeader = (BasicDetaifHeader *)[[[NSBundle mainBundle] loadNibNamed:@"BasicDetailHeaderView" owner:nil options:nil] lastObject];
    return basicHeader;
}

@end
