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
    NSDictionary *_dict;//取得的元数据
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
    
    if ([self.resuqestType isEqualToString:@"GetRiverInfo"]) {
        self.title = @"河流详情";
    }
    else if ([self.resuqestType isEqualToString:@"GetLakeInfo"])
    {
        self.title = @"水库详情";
    }
    else if ([self.resuqestType isEqualToString:@"GetPondInfo"])
    {
        self.title = @"塘坝详情";
    }
    
    [self getwebData];
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
        [RequestHttps fetchWithType:self.resuqestType Results:self.smid completion:^(NSArray *datas) {
            //成功
            if (datas.count == 0) {
                [SVProgressHUD dismissWithError:@"数据为空"];
            }else{
                [SVProgressHUD dismissWithSuccess:nil];
                _dict = datas[0];
                _list = [_dict objectForKey:@"info"];
                [self.detailTable reloadData];
            }
        } error:^(NSError *error) {
            //失败
            [SVProgressHUD dismissWithError:@"加载失败"];
        }];
    });
}

#pragma mark - UITableVIewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     TaskDetail *cell = (TaskDetail *)[[[NSBundle mainBundle] loadNibNamed:@"TaskDetail" owner:nil options:nil] lastObject];
    
    NSDictionary *dict = _list[indexPath.row];
    cell.positionLabel.text = [dict objectForKey:@"type"];
    cell.positionLabel.font = [UIFont systemFontOfSize:15];
    cell.contentLabel.text = [dict objectForKey:@"value"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    BasicDetaifHeader *basicHeader = (BasicDetaifHeader *)[[[NSBundle mainBundle] loadNibNamed:@"BasicDetailHeaderView" owner:nil options:nil] lastObject];
    if ([self.resuqestType isEqualToString:@"GetRiverInfo"]) {
        //河道
        basicHeader.riverLevelLabel.text = [NSString stringWithFormat:@"河流等级: %@",[_dict objectForKey:@"river_level"]];
        basicHeader.firstLabel.text = [NSString stringWithFormat:@"长度: %@ ㎡",[_dict objectForKey:@"length"]];
         basicHeader.secondLabel.text = [NSString stringWithFormat:@"面积: %@ km",[_dict objectForKey:@"area"]];
    }
    else if ([self.resuqestType isEqualToString:@"GetLakeInfo"])
    {
        //湖泊
        basicHeader.riverLevelLabel.text = [NSString stringWithFormat:@"河流等级: %@",[_dict objectForKey:@"lake_level"]];
        basicHeader.firstImageView.image = [UIImage imageNamed:@"area"];
        basicHeader.firstLabel.text = [NSString stringWithFormat:@"面积: %@ ㎡",[_dict objectForKey:@"area"]];
        basicHeader.secondLabel.hidden = YES;
        basicHeader.secondImageView.hidden = YES;
    }
    else{
        //塘坝
        //湖泊
        basicHeader.riverLevelLabel.hidden = YES;
        basicHeader.firstImageView.image = [UIImage imageNamed:@"area"];
        basicHeader.firstLabel.text = [NSString stringWithFormat:@"面积: %@ ㎡",[_dict objectForKey:@"area"]];
        basicHeader.secondLabel.hidden = YES;
        basicHeader.secondImageView.hidden = YES;
    }
    return basicHeader;
}

@end
