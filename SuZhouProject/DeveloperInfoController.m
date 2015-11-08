//
//  DeveloperInfoController.m
//  SuZhouProject
//  *********开发利用要素详情**********
//  Created by teddy on 15/11/8.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "DeveloperInfoController.h"
#import "TaskDetail.h"
#import "ChangeDetaiHeader.h"


@interface DeveloperInfoController ()<UITableViewDataSource,UITableViewDelegate>

{
    NSArray *_list1;
    NSArray *_list2;
    
     NSDictionary *_dict;//总得数据源
}

@property (weak, nonatomic) IBOutlet UITableView *developerInfoTable;
@end

@implementation DeveloperInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getwebData];
    UIButton *locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    locationBtn.frame = (CGRect){0,0,60,30};
    locationBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    locationBtn.layer.borderWidth = 0.3;
    locationBtn.layer.cornerRadius = 5.0;
    locationBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [locationBtn setTitle:@"地图定位" forState:UIControlStateNormal];
    [locationBtn addTarget:self action:@selector(mapLocationAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:locationBtn];
    self.navigationItem.rightBarButtonItem = right;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 *获取详情
 *simd:主键id
 */
- (void)getwebData
{
    
    [SVProgressHUD show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [RequestHttps fetchWithType:@"GetUseTypeInfo" Results:self.smid completion:^(NSArray *datas) {
            //成功
            if (datas.count == 0) {
                [SVProgressHUD dismissWithError:@"数据为空"];
            }else{
                [SVProgressHUD dismissWithSuccess:nil];
                _dict = datas[0];
                _list1 = [_dict objectForKey:@"info"];
                _list2 = [_dict objectForKey:@"approvalInfo"];
                
                [self.developerInfoTable reloadData];
            }
        } error:^(NSError *error) {
            //失败
            [SVProgressHUD dismissWithError:@"加载失败"];
        }];
    });
}

#pragma mark - private Action
//地图定位
- (void)mapLocationAction:(id)sender
{
   // [self performSegueWithIdentifier:@"detailMap" sender:nil];
}

#pragma mark - UITableVIewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        //若为信息列表
        return _list1.count;
    }else{
        return _list2.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaskDetail *cell = (TaskDetail *)[[[NSBundle mainBundle] loadNibNamed:@"TaskDetail" owner:nil options:nil] lastObject];
    cell.positionLabel.font = [UIFont systemFontOfSize:14];
    if (indexPath.section == 0) {
        //信息列表
        NSDictionary *dict = _list1[indexPath.row];
        cell.positionLabel.text = [dict objectForKey:@"type"];
        cell.contentLabel.text = [dict objectForKey:@"value"];
    }else{
        //审批列表
        NSDictionary *dict = _list2[indexPath.row];
        cell.positionLabel.text = [dict objectForKey:@"type"];
        cell.contentLabel.text = [dict objectForKey:@"value"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 60;
    }else{
        return 30;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        ChangeDetaiHeader *header = (ChangeDetaiHeader *)[[[NSBundle mainBundle] loadNibNamed:@"ChangeDetailHeaderView" owner:nil options:nil] lastObject];
        header.positionLabel.text = [_dict objectForKey:@"position"];
        header.typeImageView.image = [UIImage imageNamed:@"area"];
        header.changeDetaiLabel.text = [NSString stringWithFormat:@"面积: %@",[_dict objectForKey:@"area"]];
        
        return header;
    }else{
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:(CGRect){0,0,kScreenWidth,30}];
        headerLabel.text = @"  审批信息";
        headerLabel.font = [UIFont systemFontOfSize:14];
        headerLabel.backgroundColor = BG_COLOR;
        return headerLabel;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
