//
//  ChangeTypeController.m
//  SuZhouProject
//  ***********变化类型************
//  Created by teddy on 15/10/9.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "ChangeTypeController.h"

@interface ChangeTypeController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_list;//数据源
}
//类型列表
@property (weak, nonatomic) IBOutlet UITableView *typeTable;

@end

@implementation ChangeTypeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.typeTable.delegate = self;
    self.typeTable.dataSource = self;
    
    _list = @[@"水域变化",@"水域变化",@"水域变化",@"水域变化",@"水域变化",@"水域变化",@"水域变化",@"水域变化"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        if ([self.typeTable respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.typeTable setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
    }
#endif
    
    if ([self.typeTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.typeTable setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"myCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text = _list[indexPath.row];
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

static NSInteger _selectRow;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectRow >= 0) {
        //取消上一次选中
        NSIndexPath *oldIndex = [NSIndexPath indexPathForRow:_selectRow inSection:0];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:oldIndex];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    //新点击的cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    _selectRow = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
