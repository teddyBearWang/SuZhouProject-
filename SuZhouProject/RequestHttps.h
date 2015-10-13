//
//  RequestHttps.h
//  SuZhouProject
//  ********网络请求服务*************
//  Created by teddy on 15/10/13.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestHttps : NSObject

/*
 *requestType:网络请求的类型
 *results:需要上传的参数
 */
+ (BOOL)fetchWithType:(NSString *)requesttype Results:(NSString *)results;

/*
 *接收到得数据
 */
+ (NSArray *)requrstJsonData;

/*
 *取消网络请求
 */
+ (void)cancelRequest;

@end
