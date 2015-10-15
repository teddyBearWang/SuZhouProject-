//
//  SegtonInstance.h
//  SuZhouProject
//  ***********设置成单例模式****************
//  Created by teddy on 15/10/15.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SegtonInstance : NSObject

@property (nonatomic, strong) NSMutableArray *pathsArray;//路劲轨迹点

@property (nonatomic, assign) BOOL _isStartLocation;//是否已经开启定位

+ (SegtonInstance *)shareInstance;

@end
