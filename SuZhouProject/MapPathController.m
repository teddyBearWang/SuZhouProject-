//
//  MapPathController.m
//  SuZhouProject
//  ***********地图轨迹********
//  Created by teddy on 15/10/12.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "MapPathController.h"
#import "BMapKit.h"
#import "BMKAnnotation.h"
#import "SegtonInstance.h"
#import <CoreLocation/CoreLocation.h>

@interface MapPathController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,CLLocationManagerDelegate>
{
    BMKMapView *_mapView;
    BMKLocationService *_location;//定位服务
    SegtonInstance *_instance;//单例
    
    CLLocationManager *_locationManager;
    BMKPointAnnotation *_lastAnnotation;//上一个标注
    
}

@end

@implementation MapPathController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[_location stopUserLocationService];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _mapView = [[BMKMapView alloc] initWithFrame:self.view.frame];
    _mapView.delegate = self;
    _mapView.mapType = BMKMapTypeSatellite;
    _mapView.showsUserLocation = YES;
    
    [self.view addSubview:_mapView];
    
    _instance = [SegtonInstance shareInstance];
    if (_instance.pathsArray.count != 0) {
        //证明存在轨迹点
        //画轨迹
        [self drawPathAction];
    }
}

//画轨迹
- (void)drawPathAction
{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //若是没有打开定位服务，那么则启动定位服务
    if (!_instance._isStartLocation) {
        //界面即将显示的时候开始定位
    }
    [self startLocationAction];
}

//开始定位
- (void)startLocationAction
{
//    //设置定位精度。默认：kCLLocationAccuracyBest
//    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
//    //指定最小距离更新(米)，默认:kCLDistanceFilterNone
//    [BMKLocationService setLocationDistanceFilter:100.f];
//    _location = [[BMKLocationService alloc] init];
//    _location.delegate = self;
//    //启动定位
//    [_location startUserLocationService];
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 5;
    
    //开始定位
    [_locationManager startUpdatingLocation];
    
}

// 代理方法实现
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"%f,%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
    
    //将GPS得到的经纬度点转成百度地图的经纬度
   NSDictionary *dic =  BMKConvertBaiduCoorFrom(newLocation.coordinate, BMK_COORDTYPE_GPS);
    CLLocationCoordinate2D  coor = BMKCoorDictionaryDecode(dic);
    BMKCoordinateRegion region;
    region.center.latitude = coor.latitude;
    region.center.longitude = coor.longitude;
    region.span.latitudeDelta = 0.02;
    region.span.longitudeDelta = 0.02;
    if (_mapView) {
        _mapView.region = region;
        
    }
    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
    annotation.coordinate = coor;
    if (_mapView.annotations.count != 0) {
        //先移除上一个定位标注
        [_mapView removeAnnotation:_lastAnnotation];
    }
    [_mapView addAnnotation: annotation];
    _lastAnnotation = annotation;
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
}

#pragma mark - BMKMapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"AnnotationView"];
        newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"AnnotationView"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
      //  newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
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
