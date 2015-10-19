//
//  SegtonInstance.h
//  SuZhouProject
//  ***********设置成单例模式****************
//  Created by teddy on 15/10/15.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface SegtonInstance : NSObject

@property (nonatomic, strong) NSMutableArray *pathsArray;//路劲轨迹点

@property (nonatomic, assign) CLLocationCoordinate2D coord; //表示最新的一个经纬度点

@property (nonatomic, strong) NSString *_taskid;//任务id;

+ (SegtonInstance *)shareInstance;

@end
