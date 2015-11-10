//
//  MapPathController.m
//  SuZhouProject
//  ***********地图轨迹********
//  Created by teddy on 15/10/12.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "MapPathController.h"
//#import "BMapKit.h"
//#import "BMKAnnotation.h"
#import "SegtonInstance.h"
#import <CoreLocation/CoreLocation.h>
#import "UserLocation.h"
#import "SZMap.h"

@interface MapPathController ()<CLLocationManagerDelegate>
{

    SegtonInstance *_instance;//单例
    CLLocationManager *_locationManager;
    UserLocation *_userLocation;
    SZMapView *_szMapView;
    NSMutableArray *_polyLines;//线性数组

    
}

@end

@implementation MapPathController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[_location stopUserLocationService];
    //删除观察者
    [_userLocation removeObserver:self forKeyPath:@"userLat"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    SZSatelliteSource *onlineSource = [[SZSatelliteSource alloc] initWithApiKey:@""];
    _szMapView = [[SZMapView alloc] initWithFrame:self.view.frame andTilesource:onlineSource];
    _szMapView.zoom = 7;
    _szMapView.debugTiles = FALSE;
    //由于瓦片不是针对于retina屏幕分割的，需要激活这个功能正常显示
    _szMapView.adjustTilesForRetinaDisplay = YES;
    _szMapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    //定位到苏州市规划局附近
   // [_szMapView setCenterCoordinate:CLLocationCoordinate2DMake(31.2995098457, 120.6245023013)];
    [self.view addSubview:_szMapView];
    
    
//    _userLocation = [[UserLocation alloc] init];
//    //添加观察着这模式
//    [_userLocation addObserver:self forKeyPath:@"userLat" options:NSKeyValueObservingOptionNew context:nil];
    
    _instance = [SegtonInstance shareInstance];
    if (_instance.pathsArray.count != 0) {
        //证明存在轨迹点
        //画轨迹
        [self drawPathAction];
    }
     
}


//添加一个定位标注点
//- (void)addAnnotationAction:(CLLocationCoordinate2D)coord
//{
//    //转换成百度的坐标
//   // CLLocationCoordinate2D coorbd = [self bmapCoordFromCoordinate:coord];
//    BMKCoordinateRegion region;
//    region.center.latitude = coord.latitude;
//    region.center.longitude = coord.longitude;
//    region.span.latitudeDelta = 0.02;
//    region.span.longitudeDelta = 0.02;
//    if (_mapView) {
//        _mapView.region = region;
//    }
//    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
//    annotation.coordinate = coord;
//    if (_mapView.annotations.count != 0) {
//        //先移除上一个定位标注
//        [_mapView removeAnnotation:_lastAnnotation];
//    }
//    [_mapView addAnnotation: annotation];
//    _lastAnnotation = annotation;
//}

//画轨迹
- (void)drawPathAction
{
    int num = (int)_instance.pathsArray.count;
   // CLLocationCoordinate2D coors[num];
    _polyLines = [NSMutableArray array];
    for (int i =0; i<_instance.pathsArray.count; i++) {
        //存放经纬度的数组[纬度，精度]
        NSArray *locations = _instance.pathsArray[i];
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([locations[0] doubleValue], [locations[1] doubleValue]);
        if (i == 0) {
            [_szMapView setCenterCoordinate:coord];
        }
        CLLocation *location = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
        [_polyLines addObject:location];
    }
//    [self addAnnotationAction:coors[0]];
//    
//    BMKPolyline *polyLine = [BMKPolyline polylineWithCoordinates:coors count:num];
//    [_mapView addOverlay:polyLine];
    
    //先移除标注
    [_szMapView removeAllAnnotations];
    
    RMPolygonAnnotation *line = [[RMPolygonAnnotation alloc] initWithMapView:_szMapView points:_polyLines];
    [line setLineColor:[UIColor redColor]];
    line.lineWidth = 2;
    [_szMapView addAnnotation:line];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

//将GPS得到的经纬度点转化成百度地图上的经纬度点
//- (CLLocationCoordinate2D)bmapCoordFromCoordinate:(CLLocationCoordinate2D)coord
//{
//    NSDictionary *dict = BMKConvertBaiduCoorFrom(coord, BMK_COORDTYPE_GPS);
//    CLLocationCoordinate2D bdcoord = BMKCoorDictionaryDecode(dict);
//    return bdcoord;
//}

// 代理方法实现
//- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
//{
//    NSLog(@"%f,%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
//    
//    //将GPS得到的经纬度点转成百度地图的经纬度
//    CLLocationCoordinate2D  coor = [self bmapCoordFromCoordinate:newLocation.coordinate];
//    BMKCoordinateRegion region;
//    region.center.latitude = coor.latitude;
//    region.center.longitude = coor.longitude;
//    region.span.latitudeDelta = 0.02;
//    region.span.longitudeDelta = 0.02;
//    if (_mapView) {
//        _mapView.region = region;
//    }
//    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
//    annotation.coordinate = coor;
//    if (_mapView.annotations.count != 0) {
//        //先移除上一个定位标注
//        [_mapView removeAnnotation:_lastAnnotation];
//    }
//    [_mapView addAnnotation: annotation];
//    _lastAnnotation = annotation;
//}



//- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay{
//    if ([overlay isKindOfClass:[BMKPolyline class]]){
//        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay] ;
//        polylineView.strokeColor = [[UIColor redColor] colorWithAlphaComponent:1];
//        polylineView.lineWidth = 2.0;
//        NSLog(@"轨迹画线");
//        return polylineView;
//    }
//    return nil;
//}

//#pragma mark - BMKMapViewDelegate
//- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
//{
//    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
//        BMKPinAnnotationView *newAnnotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"AnnotationView"];
//        newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"AnnotationView"];
//        newAnnotationView.pinColor = BMKPinAnnotationColorRed;
//        return newAnnotationView;
//    }
//    return nil;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma KVO
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    if ([keyPath isEqualToString:@"userLat"]) {
//        NSLog(@"属性发了了改变");
//        _userLocation = (UserLocation *)object;
//        
//        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(_userLocation.userLat, _userLocation.userLng);
//        //转换成百度的坐标
//        CLLocationCoordinate2D coorbd = [self bmapCoordFromCoordinate:coord];
//        BMKCoordinateRegion region;
//        region.center.latitude = coorbd.latitude;
//        region.center.longitude = coorbd.longitude;
//        region.span.latitudeDelta = 0.02;
//        region.span.longitudeDelta = 0.02;
//        if (_mapView) {
//            _mapView.region = region;
//        }
//        BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
//        annotation.coordinate = coorbd;
//        if (_mapView.annotations.count != 0) {
//            //先移除上一个定位标注
//            [_mapView removeAnnotation:_lastAnnotation];
//        }
//        [_mapView addAnnotation: annotation];
//        _lastAnnotation = annotation;
//    }
//}


@end
