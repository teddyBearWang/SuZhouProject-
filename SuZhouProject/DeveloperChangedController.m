//
//  DeveloperChangedController.m
//  SuZhouProject
//  ***********开发利用要素**********
//  Created by teddy on 15/10/29.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "DeveloperChangedController.h"
#import "BasicInfoCell.h"
#import "FilterBasicInfoController.h"

@interface DeveloperChangedController ()<UITableViewDataSource,UITableViewDelegate,passFilterDelegate>
{
    NSMutableArray *_infoDataList;//数据源s
    
    NSInteger _pageCount;//页码
    NSString *_waterLevel;//水域等级
    NSString *_administrativeArea;//行政区划
    NSString *_waterName;//水域名称
    
    NSDictionary *_selectDict;//备选的
}

//开发要素列表
@property (weak, nonatomic) IBOutlet UITableView *developerTableView;
@end

@implementation DeveloperChangedController

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
    self.developerTableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    // 忽略掉底部inset
    self.developerTableView.footer.ignoredScrollViewContentInsetBottom = 10;
    // 设置footer
    self.developerTableView.footer = footer;
    
    _administrativeArea = @"";
    _waterLevel = @"";
    _waterName = @"";
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
 *name:各道名称
 *page:页码
 */
- (void)getwebData
{
    
    NSString *results  = [NSString stringWithFormat:@"%@$%@$%@$%ld",_administrativeArea,_waterLevel,_waterName,_pageCount];
    
    
    [SVProgressHUD show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [RequestHttps fetchWithType:@"GetUseTypelist" Results:results completion:^(NSArray *datas) {
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
            [self.developerTableView reloadData];
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
    
    NSString *results  = [NSString stringWithFormat:@"%@$%@$%@$%ld",_administrativeArea,_waterLevel,_waterName,_pageCount];
    [SVProgressHUD show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [RequestHttps fetchWithType:@"GetUseTypelist" Results:results completion:^(NSArray *datas) {
            //成功
            if (datas.count == 0) {
                [SVProgressHUD dismissWithError:@"无更多数据"];
            }else{
                [SVProgressHUD dismissWithSuccess:nil];
                //在原来的数据源上添加新的数据源
                for (NSDictionary *dict in datas) {
                    [_infoDataList addObject:dict];
                }
                [self.developerTableView reloadData];
            }
            [self.developerTableView.footer endRefreshing];
        } error:^(NSError *error) {
            //失败
            [SVProgressHUD dismissWithError:@"加载失败"];
        }];
    });
}


#pragma mark - Private Action
- (void)filterAction:(UIButton *)btn
{
    [self performSegueWithIdentifier:@"filterDeveloperChanged" sender:nil];
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
    InfoCell.nameLabel.text = [dict objectForKey:@"name"];
    InfoCell.lengthImage.image = [UIImage imageNamed:@"area"];
    // @"面积:2345 k㎡";

    InfoCell.lengthLabel.text = [NSString stringWithFormat:@"%@ k㎡",[dict objectForKey:@"area"]];
    InfoCell.areaImage.image = [UIImage imageNamed:@"change"];
    InfoCell.areaLabel.text = [dict objectForKey:@"water"];
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
    [self performSegueWithIdentifier:@"developerInfoDetail" sender:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"filterDeveloperChanged"]) {
        id theSegue = segue.destinationViewController;
        //filterType
        //筛选类型
        [theSegue setValue:@"水域等级" forKey:@"filterType"];
        //设置代理
        [theSegue setValue:self forKey:@"delegate"];
        [theSegue setValue:[NSString stringWithFormat:@"region$water_level"] forKey:@"requestParameter"];
        
    }
    else if ([segue.identifier isEqualToString:@"developerInfoDetail"])
    {
        //信息详情类型
        //typeInfo
        id theSegue = segue.destinationViewController;
        [theSegue setValue:[_selectDict objectForKey:@"smid"] forKey:@"smid"];
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
    _administrativeArea = administrative;
    _waterLevel = level;
    _waterName = name;
    _pageCount = 1;
    [self getwebData];
}

@end
