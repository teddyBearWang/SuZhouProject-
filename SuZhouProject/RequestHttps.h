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
 *上报图片。录音
 *results:需要上传的参数
 *images:需要上传的图片数组
 *filePath:录音的文件地址
 */
+ (BOOL)uploadWithResults:(NSString *)results withImages:(NSMutableArray *)images withRecordPath:(NSString *)filePath;
/*
 *接收到得数据
 */
+ (NSArray *)requrstJsonData;

/*
 *取消网络请求
 */
+ (void)cancelRequest;

@end
