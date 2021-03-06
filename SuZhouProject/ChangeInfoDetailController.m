//
//  ChangeInfoDetailController.m
//  SuZhouProject
//  ************变化信息详情***********
//  Created by teddy on 15/11/2.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "ChangeInfoDetailController.h"
#import "TaskDetail.h"
#import "ChangeDetaiHeader.h"

@interface ChangeInfoDetailController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_list1;//数据源1，信息列表的数据源
    NSArray *_list2;//数据源2，审批列表的数据源
    
    NSDictionary *_dict;//总得数据源
}

//变化前的图片
@property (weak, nonatomic) IBOutlet UIImageView *beforeImageView;
//变化前的时间
@property (weak, nonatomic) IBOutlet UILabel *beforeDateLabel;
//变化前的类型
@property (weak, nonatomic) IBOutlet UILabel *beforeTypeLabel;

//变化后的图片
@property (weak, nonatomic) IBOutlet UIImageView *afterImageView;
//变化后的时间
@property (weak, nonatomic) IBOutlet UILabel *afterDateLabel;
//变化后的类型
@property (weak, nonatomic) IBOutlet UILabel *afterTypeLabel;

//信息列表
@property (weak, nonatomic) IBOutlet UITableView *infoTableVIew;

@end

@implementation ChangeInfoDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getwebData];
    self.infoTableVIew.delegate =self;
    self.infoTableVIew.dataSource = self;
    self.infoTableVIew.bounces = NO;
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
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
    
    self.title = self.typeInfo;//区别
}

/*
 *获取详情
 *simd:主键id
 */
- (void)getwebData
{
    
    [SVProgressHUD show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [RequestHttps fetchWithType:@"GetChangeInfo" Results:self.smid completion:^(NSArray *datas) {
            //成功
            if (datas.count == 0) {
                [SVProgressHUD dismissWithError:@"数据为空"];
            }else{
                [SVProgressHUD dismissWithSuccess:nil];
                _dict = datas[0];
                _list1 = [_dict objectForKey:@"info"];
                _list2 = [_dict objectForKey:@"approvalInfo"];
                
                self.beforeDateLabel.text = [NSString stringWithFormat:@"%@年",[_dict objectForKey:@"beforeDate"]];
                self.beforeTypeLabel.text = [NSString stringWithFormat:@"变化前: %@",[_dict objectForKey:@"beforeType"]];
                
                self.afterDateLabel.text = [NSString stringWithFormat:@"%@年",[_dict objectForKey:@"afterDate"]];
                self.afterTypeLabel.text = [NSString stringWithFormat:@"变化后: %@",[_dict objectForKey:@"afterType"]];
                [self.infoTableVIew reloadData];
            }
        } error:^(NSError *error) {
            //失败
            [SVProgressHUD dismissWithError:@"加载失败"];
        }];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private Action
//地图定位
- (void)mapLocationAction:(id)sender
{
    [self performSegueWithIdentifier:@"changeDetailMap" sender:nil];
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
        header.changeDetaiLabel.text = [NSString stringWithFormat:@"变化面积: %@ ㎡",[_dict objectForKey:@"changeArea"]];
        
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"changeDetailMap"]) {
        id theSegue = segue.destinationViewController;
        [theSegue setValue:_dict forKey:@"PassParamter"];
    }
}

@end
