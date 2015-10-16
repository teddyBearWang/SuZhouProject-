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
    int num = (int)_instance.pathsArray.count;
    CLLocationCoordinate2D coors[] = {0};
    for (int i =0; i<_instance.pathsArray.count; i++) {
        CLLocation *location = _instance.pathsArray[i];
        CLLocationCoordinate2D bdcoord = [self bmapCoordFromCoordinate:location.coordinate];
        coors[i].latitude = bdcoord.latitude;
        coors[i].longitude = bdcoord.longitude;
    }
    
    BMKPolyline *polyLine = [BMKPolyline polylineWithCoordinates:coors count:num];
   // [_mapView removeOverlay:<#(id<BMKOverlay>)#>];
    [_mapView addOverlay:polyLine];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

//将GPS得到的经纬度点转化成百度地图上的经纬度点
- (CLLocationCoordinate2D)bmapCoordFromCoordinate:(CLLocationCoordinate2D)coord
{
    NSDictionary *dict = BMKConvertBaiduCoorFrom(coord, BMK_COORDTYPE_GPS);
    CLLocationCoordinate2D bdcoord = BMKCoorDictionaryDecode(dict);
    return bdcoord;
}

// 代理方法实现
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"%f,%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
    
    //将GPS得到的经纬度点转成百度地图的经纬度
    CLLocationCoordinate2D  coor = [self bmapCoordFromCoordinate:newLocation.coordinate];
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
        newAnnotationView.pinColor = BMKPinAnnotationColorRed;
      //  newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
