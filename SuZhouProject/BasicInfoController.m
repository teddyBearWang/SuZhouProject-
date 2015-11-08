//
//  BasicInfoController.m
//  SuZhouProject
//  *********基础信息************
//  Created by teddy on 15/10/29.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "BasicInfoController.h"
#import "BasicInfoCell.h"
#import "FilterBasicInfoController.h"

@interface BasicInfoController ()<UITableViewDataSource,UITableViewDelegate,passFilterDelegate>
{
    NSMutableArray *_infoDataList;//数据源s
    NSInteger _pageCount;
    NSString *_administrativeArea;//行政区划
    NSString *_riverLevel;//河道等级
    NSString *_startArea;//水域面积（开始）
    NSString *_endArea;//水域面积(结束)
    NSString *_riverName;//河道名称
    
    BOOL _isPond;//是否为塘坝
    
    NSDictionary *_selectDict;//选择数据源
}
@property (weak, nonatomic) IBOutlet UITableView *infoTable;

@end

@implementation BasicInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self.basicType isEqualToString:@"GetRiverlist"]) {
        self.title = @"河道";
    }
    else if ([self.basicType isEqualToString:@"GetLakelist"])
    {
        self.title = @"湖泊";
    }else{
        self.title = @"塘坝";
        _isPond = YES;
    }
    
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
    self.infoTable.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    // 忽略掉底部inset
    self.infoTable.footer.ignoredScrollViewContentInsetBottom = 10;
    // 设置footer
    self.infoTable.footer = footer;
    
    //加载数据
    [self getwebData:@"" Level:@"" startArea:@"" endArea:@"" name:@"" page:@"1"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //每次重新加载页面的时候，
    _pageCount = 1;

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

/*
 *获取河道列表(包括筛选功能)
 *administrative:行政区划
 *level:河道等级
 *start:水域面积(开始)
 *end:水域面积(结束)
 *name:各道名称
 *page:页码
 */
- (void)getwebData:(NSString *)administrative Level:(NSString *)level  startArea:(NSString *)start endArea:(NSString *)end name:(NSString *)name page:(NSString *)page
{
    //全部变量的赋值
    _administrativeArea = administrative;
    _riverLevel = level;
    _startArea = start;
    _endArea  = end;
    _riverName = name;
    
    NSString *results = nil;
    if (_isPond) {
        //塘坝 五个参数
         results  = [NSString stringWithFormat:@"%@$%@$%@$%@$%@",administrative,start,end,name,page];
    }else{
        //水库，河道
      results  = [NSString stringWithFormat:@"%@$%@$%@$%@$%@$%@",administrative,level,start,end,name,page];
    }
    
    [SVProgressHUD show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [RequestHttps fetchWithType:self.basicType Results:results completion:^(NSArray *datas) {
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
            [self.infoTable reloadData];
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
    
    NSString *results = nil;
    if (_isPond) {
        //塘坝 五个参数
        results  = [NSString stringWithFormat:@"%@$%@$%@$%@$%ld",_administrativeArea,_startArea,_endArea,_riverName,_pageCount];
    }else{
        //水库，河道
        results  = [NSString stringWithFormat:@"%@$%@$%@$%@$%@$%ld",_administrativeArea,_riverLevel,_startArea,_endArea,_riverName,_pageCount];
    }
    [SVProgressHUD show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [RequestHttps fetchWithType:self.basicType Results:results completion:^(NSArray *datas) {
            //成功
            if (datas.count == 0) {
                [SVProgressHUD dismissWithError:@"无更多数据"];
            }else{
                [SVProgressHUD dismissWithSuccess:nil];
                    //在原来的数据源上添加新的数据源
                for (NSDictionary *dict in datas) {
                    [_infoDataList addObject:dict];
                }
                [self.infoTable reloadData];
                [self.infoTable.footer endRefreshing];
            }
        } error:^(NSError *error) {
            //失败
            [SVProgressHUD dismissWithError:@"加载失败"];
        }];
    });
}

#pragma mark - Private Action
- (void)filterAction:(UIButton *)btn
{
    [self performSegueWithIdentifier:@"filterBasicInfo" sender:nil];
}

#pragma amark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _infoDataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BasicInfoCell *InfoCell = (BasicInfoCell *)[[[NSBundle mainBundle] loadNibNamed:@"BasicInfoCell" owner:nil options:nil] lastObject];
    InfoCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary *dict = _infoDataList[indexPath.row];
    InfoCell._isPond = _isPond;//是否为塘坝
    [InfoCell updateCellWith:dict];
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
    _selectDict = _infoDataList[indexPath.row];
    [self performSegueWithIdentifier:@"basicInfoDetail" sender:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //信息详情
    if ([segue.identifier isEqualToString:@"basicInfoDetail"]) {
        id theSegue = segue.destinationViewController;
        
        if ([self.basicType isEqualToString:@"GetRiverlist"]) {
           // [theSegue setValue:@"河道等级" forKey:@"filterType"];
            [theSegue setValue:@"GetRiverInfo" forKey:@"resuqestType"];
        }
        else if ([self.basicType isEqualToString:@"GetLakelist"])
        {
            [theSegue setValue:@"GetLakeInfo" forKey:@"resuqestType"];
        }else{
            [theSegue setValue:@"GetPondInfo" forKey:@"resuqestType"];
        }
        [theSegue setValue:[_selectDict objectForKey:@"smid"] forKey:@"smid"];
    }
    
    //筛选条件
    if ([segue.identifier isEqualToString:@"filterBasicInfo"]) {
        //设置代理，方便回调
        id theSegue = segue.destinationViewController;
        [theSegue setValue:self forKey:@"delegate"];
        
        //获取水域等级
        if ([self.basicType isEqualToString:@"GetRiverlist"]) {
            [theSegue setValue:@"河道等级" forKey:@"filterType"];
            [theSegue setValue:[NSString stringWithFormat:@"region$river_level"] forKey:@"requestParameter"];
        }
        else if ([self.basicType isEqualToString:@"GetLakelist"])
        {
            [theSegue setValue:@"湖泊等级" forKey:@"filterType"];
             [theSegue setValue:[NSString stringWithFormat:@"region$river_level"] forKey:@"requestParameter"];
        }else{
            [theSegue setValue:@"塘坝等级" forKey:@"filterType"];
            [theSegue setValue:[NSString stringWithFormat:@"region"] forKey:@"requestParameter"];
        }
    }
}

#pragma mark - passFilterDelegate
/*
 *传值代理
 *administrative: 行政区划
 *level:河道等级
 *start:开始面积
 *end:结束面积
 *name:河道名称
 */
- (void)passFilterValue:(NSString *)administrative riverLevel:(NSString *)level startArea:(NSString *)start endArea:(NSString *)end name:(NSString *)name
{
    
    [self getwebData:administrative Level:level startArea:start endArea:end name:name page:[NSString stringWithFormat:@"%ld",_pageCount]];
}
@end
