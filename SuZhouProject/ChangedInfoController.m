//
//  ChangedInfoController.m
//  SuZhouProject
//  ***********变化信息************
//  Created by teddy on 15/10/29.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "ChangedInfoController.h"
#import "BasicInfoCell.h"
#import "FIlterChangedController.h"


@interface ChangedInfoController ()<UITableViewDataSource,UITableViewDelegate,ChangePassFilterDelegate>
{
     NSMutableArray *_infoDataList;//数据源s
    
    NSInteger _pageCount;//页码
    NSString *_administrativeArea;//行政区划
    NSString *_riverLevel;//河道等级
    NSString *_beforeType;//变化前类型
    NSString *_afterType;//变化后类类型
    NSString *_isReasonable;//是否合理
    NSString *_startArea;//水域面积（开始）
    NSString *_endArea;//水域面积(结束)
    NSString *_riverName;//河道名称
    
    NSDictionary *_selctDict;//选择的数据源
    
}

@property (weak, nonatomic) IBOutlet UITableView *changeTable;
@end

@implementation ChangedInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *filterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    filterBtn.frame = (CGRect){0,0,30,30};
    [filterBtn setBackgroundImage:[UIImage imageNamed:@"filter"] forState:UIControlStateNormal];
    [filterBtn addTarget:self action:@selector(filterAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *filterItem = [[UIBarButtonItem alloc] initWithCustomView:filterBtn];
    self.navigationItem.rightBarButtonItem = filterItem;
    
    //设置上拉加载更多
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [footer setTitle:@"松手开始刷新.." forState:MJRefreshStatePulling];
    [footer setTitle:@"加载数据中.." forState:MJRefreshStateRefreshing];
    // 设置字体
    footer.stateLabel.font = [UIFont systemFontOfSize:17];
    // 设置颜色
    footer.stateLabel.textColor = [UIColor lightGrayColor];
    // 设置了底部inset
    self.changeTable.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    // 忽略掉底部inset
    self.changeTable.footer.ignoredScrollViewContentInsetBottom = 10;
    // 设置footer
    self.changeTable.footer = footer;
    
    _administrativeArea = @"";
    _riverLevel = @"";
    _beforeType = @"";
    _afterType = @"";
    _isReasonable = @"";
    _startArea = @"";
    _endArea = @"";
    _riverName = @"";
    _pageCount = 1;
    [self getwebData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //每次重新加载页面的时候，
    _pageCount = 1;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
 *获取河道列表(包括筛选功能)
 *administrative:行政区划
 *level:水域等级
 *before:变化前类型
 *after:变化后类型
 *resonable:是否合理
 *start:水域面积(开始)
 *end:水域面积(结束)
 *name:各道名称
 *page:页码
 */
- (void)getwebData
{

    NSString *results  = [NSString stringWithFormat:@"%@$%@$%@$%@$%@$%@$%@$%@$%@$%ld",_administrativeArea,_riverLevel,_beforeType,_afterType,_isReasonable,_startArea,_endArea,_riverName,self.changeType,_pageCount];

    
    [SVProgressHUD show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [RequestHttps fetchWithType:@"GetChangelist" Results:results completion:^(NSArray *datas) {
            //成功
            if (datas.count == 0) {
                [SVProgressHUD dismissWithError:@"数据为空"];
            }else{
                [SVProgressHUD dismissWithSuccess:nil];
            }
            if (!_infoDataList) {
                _infoDataList = [NSMutableArray array];
            }else{
                [_infoDataList removeAllObjects];
            }
            //先删除原有的，在添加现有的数据源
            for (NSDictionary *dict in datas) {
                [_infoDataList addObject:dict];
            }
            [self.changeTable reloadData];
        } error:^(NSError *error) {
            //失败
            [SVProgressHUD dismissWithError:@"加载失败"];
        }];
    });
}

#pragma mark - LoadMoreData
- (void)loadMoreData
{
   
    //页码加1
    _pageCount ++;
    
     NSString *results  = [NSString stringWithFormat:@"%@$%@$%@$%@$%@$%@$%@$%@$%@$%ld",_administrativeArea,_riverLevel,_beforeType,_afterType,_isReasonable,_startArea,_endArea,_riverName,self.changeType,_pageCount];
    [SVProgressHUD show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [RequestHttps fetchWithType:@"GetChangelist" Results:results completion:^(NSArray *datas) {
            //成功
            if (datas.count == 0) {
                [SVProgressHUD dismissWithError:@"无更多数据"];
            }else{
                [SVProgressHUD dismissWithSuccess:nil];
                //在原来的数据源上添加新的数据源
                for (NSDictionary *dict in datas) {
                    [_infoDataList addObject:dict];
                }
                [self.changeTable reloadData];
            }
            [self.changeTable.footer endRefreshing];
        } error:^(NSError *error) {
            //失败
            [SVProgressHUD dismissWithError:@"加载失败"];
        }];
    });
}

#pragma mark - Private Action
- (void)filterAction:(UIButton *)btn
{
    [self performSegueWithIdentifier:@"filterChangedInfo" sender:nil];
}

#pragma amark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   // return 10;
    return _infoDataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BasicInfoCell *InfoCell = (BasicInfoCell *)[[[NSBundle mainBundle] loadNibNamed:@"BasicInfoCell" owner:nil options:nil] lastObject];
    InfoCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary *dict = _infoDataList[indexPath.row];
    InfoCell.nameLabel.text = [dict objectForKey:@"name"];
    InfoCell.lengthImage.image = [UIImage imageNamed:@"length"];
    InfoCell.lengthLabel.text = [NSString stringWithFormat:@"%@ ㎡",[dict objectForKey:@"area"]];
    InfoCell.areaImage.image = [UIImage imageNamed:@"change"];
    InfoCell.areaLabel.text = [NSString stringWithFormat:@"%@ -> %@",[dict objectForKey:@"before"],[dict objectForKey:@"after"]];
    return InfoCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
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
    _selctDict = _infoDataList[indexPath.row];
    [self performSegueWithIdentifier:@"changInfoDetail" sender:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //筛选
    if ([segue.identifier isEqualToString:@"filterChangedInfo"]) {
        id theSegue = segue.destinationViewController;
        [theSegue setValue:@"变化信息" forKey:@"filterType"];
        [theSegue setValue:self forKey:@"delegate"];
        
    }
    //详情
    else if ([segue.identifier isEqualToString:@"changInfoDetail"])
    {
        id theSegue = segue.destinationViewController;
        [theSegue setValue:@"变化信息" forKey:@"typeInfo"];
        [theSegue setValue:[_selctDict objectForKey:@"smid"] forKey:@"smid"];
        
    }
}

#pragma mark- ChangePassFilterDelegate
/*
 *传值代理
 *administrative: 行政区划
 *level:水域等级
 *before:变化前的类型
 *after:变化后的类型
 *resonable:是否合理
 *start:开始面积
 *end:结束面积
 *name:河道名称
 */
- (void)changePassFilterValue:(NSString *)administrative riverLevel:(NSString *)level beforeType:(NSString *)before
                    afterType:(NSString *)after isResonable:(NSString *)resonable startArea:(NSString *)start endArea:(NSString *)end name:(NSString *)name
{
    //    //全部变量的赋值
        _administrativeArea = administrative;
        _riverLevel = level;
        _beforeType = before;
        _afterType = after;
        _isReasonable = resonable;
        _startArea = start;
        _endArea  = end;
        _riverName = name;
    _pageCount = 1;
    [self getwebData];
}
@end
