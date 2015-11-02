//
//  DetailMapController.m
//  SuZhouProject
//  ***********信息详情里面的地图定位**********
//  Created by teddy on 15/11/2.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "DetailMapController.h"
#import "BMapKit.h"

@interface DetailMapController ()
{
    BMKMapView *_mapView;
}

@end

@implementation DetailMapController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _mapView = [[BMKMapView alloc] initWithFrame:self.view.frame];
    _mapView.mapType = BMKMapTypeSatellite;
    _mapView.showsUserLocation = YES;
    _mapView.zoomLevel = 16;
    [self.view addSubview:_mapView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
