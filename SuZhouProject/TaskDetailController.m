//
//  TaskDetailController.m
//  SuZhouProject
//  **********任务详情************
//  Created by teddy on 15/9/30.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "TaskDetailController.h"
#import "TaskDetail.h"
#import "MapPathController.h"
#import "SVProgressHUD.h"
#import "RequestHttps.h"
#import <CoreLocation/CoreLocation.h>
#import "SegtonInstance.h"
#import "UserLocation.h"
#import "SZMap.h"

@interface TaskDetailController ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>
{
    NSArray *_dataList; //数据源
    SZMapView *_szMapView;
    CLLocationManager *_locationManager;//自动的定位服务
    SegtonInstance *_instance;//单例
    UserLocation *_userLocation;//用户的信息
    
}
//开始巡查按钮
@property (weak, nonatomic) IBOutlet UIButton *start_btn;
//巡查上报按钮
@property (weak, nonatomic) IBOutlet UIButton *upload_btn;
//更新上报按钮
@property (weak, nonatomic) IBOutlet UIButton *updateBtn;

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
    
    _userLocation = [[UserLocation alloc] init];
    _instance = [SegtonInstance shareInstance];
    if (_instance.pathsArray == nil) {
        _instance.pathsArray = [NSMutableArray array];
    }

    
    SZSatelliteSource *onlineSource = [[SZSatelliteSource alloc] initWithApiKey:@""];
    _szMapView = [[SZMapView alloc] initWithFrame:self.mapShowView.frame andTilesource:onlineSource];
    _szMapView.zoom = 3;
    _szMapView.debugTiles = FALSE;
    //由于瓦片不是针对于retina屏幕分割的，需要激活这个功能正常显示
    _szMapView.adjustTilesForRetinaDisplay = YES;
    _szMapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    //定位到苏州市规划局附近
    [_szMapView setCenterCoordinate:CLLocationCoordinate2DMake(31.2995098457, 120.6245023013)];
    [self.mapShowView addSubview:_szMapView];
    
    [self polygon];
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

/***
 根据给定的位置坐标,画一条一个封闭区域
 */
- (void)polygon {
    NSLog(@"polygon");
    //先清除现有的标注层
    [_szMapView removeAllAnnotations]; //随机生成5个位置坐标,将他们放置在一个数组中
    NSArray *locations = [NSArray arrayWithObjects:[ [CLLocation alloc]
                                                    initWithLatitude:31.351595 longitude:120.635000], [[CLLocation alloc]
                                                                                                       initWithLatitude:31.323595 longitude:120.575542], [[CLLocation alloc]
                                                                                                                                                          initWithLatitude:31.283560 longitude:120.568450],[[CLLocation alloc]
                                                                                                                                                                                                            initWithLatitude:31.283560 longitude:120.655845], [[CLLocation alloc]
                                                                                                                                                                                                                                                               initWithLatitude:31.344666 longitude:120.655016], nil]; //创建一个多边形标注
    RMPolygonAnnotation *shape = [[RMPolygonAnnotation alloc]
                                  initWithMapView:_szMapView points:locations];
    
    //设定线条颜色为蓝
    [shape setLineColor:[UIColor blueColor]]; //设定填充色为半透明蓝
    [shape setFillColor:[UIColor colorWithRed:0.0 green:0.0 blue:1.0
                                        alpha:0.5]];
    //将标注贴到地图上
    [_szMapView addAnnotation:shape];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getRequestJsonData:self.taskId];
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
    [SVProgressHUD showWithStatus:nil];
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
            [SVProgressHUD dismissWithSuccess:nil];
            _dataList = list;
            [self.taskTable reloadData];
            
            if ([[list[0] objectForKey:@"state"] isEqualToString:@"未巡查"]) {
                self.start_btn.hidden = NO;
                self.upload_btn.hidden = YES;
                self.end_btn.hidden = YES;
                self.updateBtn.hidden = YES;
            }
            else if ([[list[0] objectForKey:@"state"] isEqualToString:@"巡查中"])
            {
                self.start_btn.hidden = YES;
                self.upload_btn.hidden = NO;
                self.end_btn.hidden = NO;
                self.updateBtn.hidden = YES;
            }
            else if ([[list[0] objectForKey:@"state"] isEqualToString:@"已完成"])
            {
                 self.start_btn.hidden = YES;
                 self.upload_btn.hidden = YES;
                 self.end_btn.hidden = YES;
                self.updateBtn.hidden = NO;//更新上报按钮，显示
            }
        }else{
            [SVProgressHUD dismissWithSuccess:@"加载失败"];
        }
    });
}

#pragma mark - Private Method

//开始巡查
- (IBAction)startPartrolAction:(id)sender
{
    
    //得开始判断，是不是存在正在巡查的任务，若是存在，则需要停止
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([[user objectForKey:Partrol_State] isEqualToString:@"YES"]) {
        //表示存在正在巡查的任务
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"您存在正在巡查的任务,请先结束该巡查任务" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    //若无正在巡查的任务，则开始调取开始巡查的服务
    NSString *result = [NSString stringWithFormat:@"%@$巡查中",self.taskId];
    [SVProgressHUD showWithStatus:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [RequestHttps fetchWithType:@"UpdateState" Results:result completion:^(NSArray *datas) {
            NSDictionary *dict = datas[0];
            if ([[dict objectForKey:@"success"] isEqualToString:@"True"]) {
                [SVProgressHUD dismissWithSuccess:nil];
                //开启定位
                [self startUpdateLocation];
                self.start_btn.hidden = YES;
                self.upload_btn.hidden = NO;
                self.end_btn.hidden = NO;
                //表示有任务正在巡查
                [user setValue:@"YES" forKey:Partrol_State];
                [user synchronize];
            }else{
                [SVProgressHUD dismissWithError:@"开始巡查失败"];
            }
        } error:^(NSError *error) {
             [SVProgressHUD dismissWithError:@"开始巡查失败"];
        }];
    });
}

//开启定位
- (void)startUpdateLocation
{
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

//传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"uploadPartrol"]) {
        id theSegue = segue.destinationViewController;
        [theSegue setValue:self.taskId forKey:@"taskId"];
    }
}

//结束巡查
- (IBAction)endPartrolAction:(id)sender
{
    
    NSString *result = [NSString stringWithFormat:@"%@$已完成",self.taskId];
    [SVProgressHUD showWithStatus:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [RequestHttps fetchWithType:@"UpdateState" Results:result completion:^(NSArray *datas) {
            NSDictionary *dict = datas[0];
            if ([[dict objectForKey:@"success"] isEqualToString:@"True"]) {
                [SVProgressHUD dismissWithSuccess:nil];
                self.start_btn.hidden = YES;
                self.upload_btn.hidden = YES;
                self.end_btn.hidden = YES;
                self.updateBtn.hidden = NO;//更新上报按钮，显示
                
                //关闭定位
                if (![_locationManager locationServicesEnabled]) {
                    //关闭定位服务
                    [_locationManager stopUpdatingLocation];
                }
                //将正在巡查的标志变成“NO”
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                [user setValue:@"NO" forKey:Partrol_State];
                [user synchronize];
            }else{
                [SVProgressHUD dismissWithError:nil];
            }
        } error:^(NSError *error) {
            [SVProgressHUD dismissWithError:@"结束巡查失败"];
        }];
    });
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
    _instance.coord = location.coordinate;//更新
    //修改用户的地点经纬度位置
    _userLocation.userLat = location.coordinate.latitude;
    _userLocation.userLng = location.coordinate.longitude;
    NSLog(@"定位得到的纬度； %lf    精度: %lf",_userLocation.userLat,_userLocation.userLng);
    NSNumber *lat = [NSNumber numberWithDouble:location.coordinate.latitude];
    NSNumber *lng = [NSNumber numberWithDouble:location.coordinate.longitude];

    //将得到的经纬度对象添加到路径数组中
    NSArray *locationArray = [NSArray arrayWithObjects:lat, lng,nil];
    [_instance.pathsArray addObject:locationArray];
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
