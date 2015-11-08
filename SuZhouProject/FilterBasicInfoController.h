//
//  FilterBasicInfoController.h
//  SuZhouProject
//
//  Created by teddy on 15/10/29.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "RootViewController.h"

@protocol passFilterDelegate <NSObject>

/*
 *传值代理
 *administrative: 行政区划
 *level:河道等级
 *start:开始面积
 *end:结束面积
 *name:河道名称
 */
- (void)passFilterValue:(NSString *)administrative riverLevel:(NSString *)level startArea:(NSString *)start endArea:(NSString *)end name:(NSString *)name;

@end

@interface FilterBasicInfoController : RootViewController

@property (strong, nonatomic) id<passFilterDelegate>delegate;

@property (nonatomic, strong) NSString *filterType;//筛选的类型

@property (nonatomic, copy) NSString *requestParameter;//传递的参数

@end
