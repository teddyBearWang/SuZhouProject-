//
//  ThirdViewController.m
//  SuZhouProject
//  *************资料**************
//  Created by teddy on 15/9/30.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "ThirdViewController.h"

@interface ThirdViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_List1;//数据源
    NSArray *_List2;//数据源
    NSArray *_List3;//数据源
}
@property (weak, nonatomic) IBOutlet UITableView *dataTable;

@end

@implementation ThirdViewController

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
#if __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        if ([self.dataTable respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.dataTable setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
    }
#endif
    if ([self.dataTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.dataTable setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"资料";
    
    self.dataTable.backgroundColor = BG_COLOR;
    self.dataTable.delegate  = self;
    self.dataTable.dataSource = self;
    
    _List1 = @[@"河道: 数量100条 面积100k㎡",@"湖泊: 数量100个 面积100k㎡",@"塘坝: 数量100个 面积100k㎡"];
    _List2 = @[@"水域增加: 变化点20处 面积100㎡",@"水域减少: 变化点20处 面积100㎡",@"跨河建筑工程: 变化点20处 面积100㎡",@"开发利用变化: 变化点20处 面积100㎡"];
    _List3 = @[@"水域增加: 变化点20处 面积100㎡"];
}

//切换界面的时候
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return _List1.count;
            break;
        case 1:
            return _List2.count;
            break;
        case 2:
            return _List3.count;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"myCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    switch (indexPath.section) {
        case 0:
        {
            cell.textLabel.text = _List1[indexPath.row];
        }
            break;
        case 1:
        {
            cell.textLabel.text = _List2[indexPath.row];
        }
            break;
        case 2:
        {
            cell.textLabel.text = _List3[indexPath.row];
        }
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
#if __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
    }
#endif
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    textLabel.backgroundColor = [UIColor lightGrayColor];
    textLabel.textColor = [UIColor blueColor];
    textLabel.font = [UIFont systemFontOfSize:15];
    switch (section) {
        case 0:
        {
            textLabel.text = @"   基础信息";
        }
            break;
        case 1:
        {
            textLabel.text = @"   变化信息";
        }
            break;
        case 2:
        {
            textLabel.text = @"   利用开发要素";
        }
            break;
        default:
            return nil;
            break;
    }
    return textLabel;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            //基础信息
            [self performSegueWithIdentifier:@"basicInfo" sender:nil];
        }
            break;
        case 1:
        {
            //变化信息
             [self performSegueWithIdentifier:@"changedInfo" sender:nil];
        }
            break;
        case 2:
        {
            //利用开发要素
            [self performSegueWithIdentifier:@"DeveloperChanged" sender:nil];
        }
            break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    id theSegue = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"basicInfo"]) {
        [theSegue setValue:@"基础信息" forKey:@"basicType"];
    }
    else if ([segue.identifier isEqualToString:@"changedInfo"])
    {
        [theSegue setValue:@"变化信息" forKey:@"changeType"];
    }
    else
    {
         [theSegue setValue:@"开发利用要素" forKey:@"developeType"];
    }
}

@end
