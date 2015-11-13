//
//  DetailMapController.m
//  SuZhouProject
//  ***********信息详情里面的地图定位**********
//  Created by teddy on 15/11/2.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "DetailMapController.h"
#import "SZMap.h"

@interface DetailMapController ()<RMMapViewDelegate>
{
    SZMapView *_szMapView;

}

@end

@implementation DetailMapController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"传递进来的数据是：%@",self.PassParamter);
    SZSatelliteSource *onlineSource = [[SZSatelliteSource alloc] initWithApiKey:@""];
    _szMapView = [[SZMapView alloc] initWithFrame:self.view.frame andTilesource:onlineSource];
    _szMapView.zoom = 8;
    _szMapView.delegate = self;
    _szMapView.debugTiles = FALSE;
    //由于瓦片不是针对于retina屏幕分割的，需要激活这个功能正常显示
    _szMapView.adjustTilesForRetinaDisplay = YES;
    _szMapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    //定位到苏州市规划局附近
    [self addPotion];
    
   // [_szMapView setCenterCoordinate:CLLocationCoordinate2DMake(31.2995098457, 120.6245023013)];
    [_szMapView setCenterCoordinate:CLLocationCoordinate2DMake([[self.PassParamter objectForKey:@"latitude"] floatValue], [[self.PassParamter objectForKey:@"longitude"] floatValue])];
    [self.view addSubview:_szMapView];
    
    
    //[self polygon];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/***
 根据给定的位置坐标,添加一个标注
 */
- (void)addPotion
{
    [_szMapView removeAllAnnotations];
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([[self.PassParamter objectForKey:@"latitude"] floatValue], [[self.PassParamter objectForKey:@"longitude"] floatValue]);
    RMPointAnnotation *annoatation = [[RMPointAnnotation alloc] initWithMapView:_szMapView coordinate:coord andTitle:@"当前位置"];
    //RMAnnotation *annoatation = [RMAnnotation annotationWithMapView:_szMapView coordinate:coord andTitle:@"当前"];
    annoatation.annotationType = @"RMClusterAnnotation";
    annoatation.annotationIcon = [UIImage imageNamed:@"location"];
    annoatation.badgeIcon = [UIImage imageNamed:@"location"];
    [_szMapView addAnnotation:annoatation];
}


@end
