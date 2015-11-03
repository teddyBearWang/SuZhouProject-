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
}
@property (weak, nonatomic) IBOutlet UITableView *messageTable;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"消息";
    _infoDataList = [NSMutableArray arrayWithObjects:@"这是一个新的巡查内容，请你按时去完成巡查并登记上报",@"这是一个新的巡查内容，请你按时去完成巡查并登记上报",@"这是一个新的巡查内容，请你按时去完成巡查并登记上报",@"这是一个新的巡查内容，请你按时去完成巡查并登记上报", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [InfoCell updateCellUI:nil];
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
//    else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    id theSegue = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"messageDetail"]) {
        [theSegue setValue:@"选择行数" forKey:@"passParameter"];
    }
}


@end
