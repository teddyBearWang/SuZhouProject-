//
//  RequestHttps.m
//  SuZhouProject
//
//  Created by teddy on 15/10/13.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "RequestHttps.h"
#import <AFNetworking.h>

static AFHTTPRequestOperation *_operation = nil;
@implementation RequestHttps

/*
 *requestType:网络请求的类型
 *results:需要上传的参数
 */
+ (BOOL)fetchWithType:(NSString *)requesttype Results:(NSString *)results
{
    //http://115.236.2.245:48056/szsydtServ/Data.ashx?t=Login&results=sys$123456&returntype=json
    BOOL ret;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 30;//设置超时时间
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parmater = @{@"t":requesttype,
                               @"results":results,
                               @"returntype":@"json"};
    _operation = [manager POST:REQUEST_URL parameters:parmater success:nil failure:nil];
    [_operation waitUntilFinished];
    if (_operation.responseData != nil) {
        ret = YES;
        datas = [NSJSONSerialization JSONObjectWithData:_operation.responseData  options:NSJSONReadingMutableContainers error:nil];
    }
    return ret;
}

/*
 *接收到得数据
 */
static NSArray *datas = nil;
+ (NSArray *)requrstJsonData
{
    return datas;
}

/*
 *取消网络请求
 */
+ (void)cancelRequest
{
    if (_operation != nil) {
        [_operation cancel];
    }
}


@end
