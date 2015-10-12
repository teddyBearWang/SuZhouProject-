//
//  MapPathController.m
//  SuZhouProject
//  ***********地图轨迹********
//  Created by teddy on 15/10/12.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "MapPathController.h"
#import "BMapKit.h"

@interface MapPathController ()<BMKMapViewDelegate,BMKLocationServiceDelegate>
{
    BMKMapView *_mapView;
    BMKLocationService *_location;//定位服务
}

@end

@implementation MapPathController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_location stopUserLocationService];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _mapView = [[BMKMapView alloc] initWithFrame:self.view.frame];
    _mapView.delegate = self;
    _mapView.mapType = BMKMapTypeSatellite;
    _mapView.showsUserLocation = YES;
    
    [self.view addSubview:_mapView];
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
    _location = [[BMKLocationService alloc] init];
    _location.delegate = self;
    //启动定位
    [_location startUserLocationService];
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
