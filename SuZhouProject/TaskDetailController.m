//
//  TaskDetailController.m
//  SuZhouProject
//  **********任务详情************
//  Created by teddy on 15/9/30.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "TaskDetailController.h"
#import "TaskDetail.h"
#import "BMapKit.h"
#import "MapPathController.h"
#import "SVProgressHUD.h"
#import "RequestHttps.h"
#import <CoreLocation/CoreLocation.h>
#import "SegtonInstance.h"

@interface TaskDetailController ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>
{
    NSArray *_dataList; //数据源
    BMKMapView *_mapView;
   // BMKLocationService *_locationService;//定位服务
    CLLocationManager *_locationManager;//自动的定位服务
    SegtonInstance *_instance;//单例
    
}
//开始巡查按钮
@property (weak, nonatomic) IBOutlet UIButton *start_btn;
//巡查上报按钮
@property (weak, nonatomic) IBOutlet UIButton *upload_btn;
//结束按钮
@property (weak, nonatomic) IBOutlet UIButton *end_btn;
//任务列表
@property (weak, nonatomic) IBOutlet UITableView *taskTable;

//显示轨迹的地图
@property (weak, nonatomic) IBOutlet UIView *mapShowView;


//开始巡查
- (IBAction)startPartrolAction:(id)sender;
//巡查上报
- (IBAction)partrolUploadAction:(id)sender;
//结束巡查
- (IBAction)endPartrolAction:(id)sender;


@end

@implementation TaskDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.taskTable.delegate = self;
    self.taskTable.dataSource = self;
    self.taskTable.scrollEnabled = NO;//禁止滑动
    
    _instance = [SegtonInstance shareInstance];
    if (_instance.pathsArray == nil) {
        _instance.pathsArray = [NSMutableArray array];
    }
//
    _mapView = [[BMKMapView alloc] initWithFrame:self.mapShowView.frame];
    _mapView.mapType = BMKMapTypeSatellite;
    _mapView.showsUserLocation = YES;
    [self.mapShowView addSubview:_mapView];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //取消网络请求
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        [RequestHttps cancelRequest];
        [SVProgressHUD dismiss];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getRequestJsonData:self.taskId];
    //界面即将显示的时候开始定位
}


- (void)viewWillLayoutSubviews
{
    
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        if ([self.taskTable respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.taskTable setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
    }
#endif
    
    if ([self.taskTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.taskTable setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getWebData
- (void)getRequestJsonData:(NSString *)results
{
    [SVProgressHUD showWithStatus:@"加载中"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([RequestHttps fetchWithType:@"GetTaskInfo" Results:results]) {
            [self updateUI];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismissWithError:@"加载失败"];
            });
        }
    });
}

- (void)updateUI
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSArray *list = [RequestHttps requrstJsonData];
        if (list.count != 0) {
            [SVProgressHUD dismissWithSuccess:@"加载成功"];
            _dataList = list;
            [self.taskTable reloadData];
        }else{
            [SVProgressHUD dismissWithSuccess:@"加载失败"];
        }
    });
}

#pragma mark - Private Method

//开始巡查
- (IBAction)startPartrolAction:(id)sender
{
    self.start_btn.hidden = YES;
    self.upload_btn.hidden = NO;
    self.end_btn.hidden = NO;
    
    //开启定位服务
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 5;
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 8.0) {
        [_locationManager requestWhenInUseAuthorization];//8.0以上的系统，要经过这句话的授权，才会弹框定位
    }
    
#endif
    
    //开启定位功能
    [_locationManager startUpdatingLocation];
    
}

//巡查上报
- (IBAction)partrolUploadAction:(id)sender
{
    [self performSegueWithIdentifier:@"uploadPartrol" sender:nil];
}

//结束巡查
- (IBAction)endPartrolAction:(id)sender
{
    if (![_locationManager locationServicesEnabled]) {
        //关闭定位服务
        [_locationManager stopUpdatingLocation];
    }
}

- (void)watchMapPathAction
{
    [self performSegueWithIdentifier:@"mapPath" sender:nil];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    NSLog(@"定位得到的纬度； %lf    精度: %lf",location.coordinate.latitude,location.coordinate.longitude);
    _instance.coord = location.coordinate;//更新
    //将得到的经纬度对象添加到路径数组中
    [_instance.pathsArray addObject:location];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
   NSLog(@"定位失败的错误是:%@",error);
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaskDetail *cell = (TaskDetail *)[[[NSBundle mainBundle] loadNibNamed:@"TaskDetail" owner:nil options:nil] lastObject];
    NSDictionary *dict = _dataList[0];
    switch (indexPath.row) {
        case 0:
        {
            cell.positionLabel.text = @"巡查水域";
            cell.contentLabel.text = [dict objectForKey:@"watername"];
            cell.postionButton.hidden = NO;//显示按钮
            [cell.postionButton addTarget:self action:@selector(watchMapPathAction) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case 1:
        {
            cell.positionLabel.text = @"任务名称";
            cell.contentLabel.text = [dict objectForKey:@"taskname"];
        }
            break;
        case 2:
        {
            cell.positionLabel.text = @"任务类型";
            cell.contentLabel.text = [dict objectForKey:@"type"];
        }
            break;
        case 3:
        {
            cell.positionLabel.text = @"任务内容";
            cell.contentLabel.text = [dict objectForKey:@"content"];
        }
            break;
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
    }
#endif
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
