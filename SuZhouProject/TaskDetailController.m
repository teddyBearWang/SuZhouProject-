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

@interface TaskDetailController ()<UITableViewDataSource,UITableViewDelegate,BMKLocationServiceDelegate>
{
    NSArray *_dataList; //数据源
    BMKMapView *_mapView;
    BMKLocationService *_locationService;//定位服务
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
    
    _mapView = [[BMKMapView alloc] initWithFrame:self.mapShowView.frame];
    _mapView.mapType = BMKMapTypeSatellite;
    _mapView.showsUserLocation = YES;
    [self.mapShowView addSubview:_mapView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //界面即将显示的时候开始定位
    [self startLocationAction];
}

//开始定位
- (void)startLocationAction
{
    //设置定位精度。默认：kCLLocationAccuracyBest
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    //指定最小距离更新(米)，默认:kCLDistanceFilterNone
    [BMKLocationService setLocationDistanceFilter:100.f];
    _locationService = [[BMKLocationService alloc] init];
    _locationService.delegate = self;
    //启动定位
    [_locationService startUserLocationService];
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

#pragma mark - BMKLocationServiceDelegate

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 //处理方向变更信息
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    NSLog(@"hedding is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 处理位置坐标更新
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    BMKCoordinateRegion region;
    region.center.latitude = userLocation.location.coordinate.latitude;
    region.center.longitude = userLocation.location.coordinate.longitude;
    region.span.latitudeDelta = 0.02;
    region.span.longitudeDelta = 0.02;
    if (_mapView) {
        _mapView.region = region;

    }
    //加上这句话，才会显示定位的蓝圆点，否则不显示
    [_mapView updateLocationData:userLocation];
    [_locationService stopUserLocationService];
}

#pragma mark - Private Method

//开始巡查
- (IBAction)startPartrolAction:(id)sender
{
    self.start_btn.hidden = YES;
    self.upload_btn.hidden = NO;
    self.end_btn.hidden = NO;
}

//巡查上报
- (IBAction)partrolUploadAction:(id)sender
{
    [self performSegueWithIdentifier:@"uploadPartrol" sender:nil];
}

//结束巡查
- (IBAction)endPartrolAction:(id)sender {
}

- (void)watchMapPathAction
{
    [self performSegueWithIdentifier:@"mapPath" sender:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaskDetail *cell = (TaskDetail *)[[[NSBundle mainBundle] loadNibNamed:@"TaskDetail" owner:nil options:nil] lastObject];
    switch (indexPath.row) {
        case 0:
        {
            cell.positionLabel.text = @"巡查水域";
            cell.contentLabel.text = @"钱塘江沿岸";
            cell.postionButton.hidden = NO;//显示按钮
            [cell.postionButton addTarget:self action:@selector(watchMapPathAction) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case 1:
        {
            cell.positionLabel.text = @"任务名称";
            cell.contentLabel.text = @"观察水域变化情况";
        }
            break;
        case 2:
        {
            cell.positionLabel.text = @"任务类型";
            cell.contentLabel.text = @"日常巡查";
        }
            break;
        case 3:
        {
            cell.positionLabel.text = @"任务内容";
            cell.contentLabel.text = @"观察水域变化，上报情况";
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
