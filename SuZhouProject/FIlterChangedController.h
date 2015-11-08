//
//  FIlterChangedController.h
//  SuZhouProject
//
//  Created by teddy on 15/10/29.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "RootViewController.h"

@protocol ChangePassFilterDelegate <NSObject>

/*
 *传值代理
 *administrative: 行政区划
 *level:水域等级
 *before:变化前的类型
 *after:变化后的类型
 *resonable:是否合理
 *start:开始面积
 *end:结束面积
 *name:河道名称
 */
- (void)changePassFilterValue:(NSString *)administrative riverLevel:(NSString *)level beforeType:(NSString *)before
                    afterType:(NSString *)after isResonable:(NSString *)resonable startArea:(NSString *)start endArea:(NSString *)end name:(NSString *)name;

@end

@interface FIlterChangedController : RootViewController

@property (nonatomic, strong) NSString *filterType;//筛选类型

@property (nonatomic) id<ChangePassFilterDelegate>delegate;

@end
