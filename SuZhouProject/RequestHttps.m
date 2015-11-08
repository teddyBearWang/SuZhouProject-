//
//  RequestHttps.m
//  SuZhouProject
//
//  Created by teddy on 15/10/13.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "RequestHttps.h"


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
 *新的网络请求服务
 *requestType:网络请求的类型
 *results:需要上传的参数
 *completionBlock:成功的回调
 *errorBlock:失败的回调
 */
+ (void)fetchWithType:(NSString *)requesttype Results:(NSString *)results
           completion:(ComplettionBlock)completionBlock
                error:(ErrorBlock)errorBlock
{
    //http://115.236.2.245:48056/szsydtServ/Data.ashx?t=Login&results=sys$123456&returntype=json
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 30;//设置超时时间
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parmater = @{@"t":requesttype,
                               @"results":results,
                               @"returntype":@"json"};
    _operation = [manager POST:REQUEST_URL parameters:parmater success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //成功
        NSArray *data = [NSJSONSerialization JSONObjectWithData:_operation.responseData  options:NSJSONReadingMutableContainers error:nil];
        completionBlock(data);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //失败
        errorBlock(error);
    }];
   
}


/*
 *上报图片。录音
 *results:需要上传的参数
 *images:需要上传的图片数组
 *filePath:录音的文件地址
 */
+ (void)uploadWithResults:(NSString *)results withImages:(NSMutableArray *)images withRecordPath:(NSString *)filePath
               completion:(ComplettionBlock)completionBlock
                    error:(ErrorBlock)errorBlock
{
 
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parmater = @{@"t":@"SetTask",
                               @"results":results,
                               @"returntype":@"json"};
    _operation = [manager POST:REQUEST_URL parameters:parmater constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //上传多张照片和录音
        for (int i=0; i<images.count-1; i++) {
            NSData *imageData = UIImagePNGRepresentation(images[i]);
            //上传的参数名
            NSString *name = [NSString stringWithFormat:@"image%d",i];
            //上传的fileName
            NSString *fileName = [NSString stringWithFormat:@"%@.png",name];
            [formData appendPartWithFileData:imageData name:fileName fileName:fileName mimeType:@"application/octet-stream"];
        }
        
        
        
        NSFileManager *manager = [NSFileManager defaultManager];
        if ([manager fileExistsAtPath:filePath]) {
            NSDate *now = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *dateString = [formatter stringFromDate:now];
            NSString *fileName = [NSString stringWithFormat:@"%@.aac",dateString];
            NSData *recordData = [[NSData alloc] initWithContentsOfFile:filePath];
            [formData appendPartWithFileData:recordData name:fileName fileName:fileName mimeType:@"application/octet-stream"];
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
       NSArray *data = [NSJSONSerialization JSONObjectWithData:responseObject  options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"得到的数据时:%@",responseObject);
        NSLog(@"得到的数据三:%@",operation.responseString);
         NSLog(@"得到的数据时:%@",data);
        completionBlock(data);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSArray *data = [NSJSONSerialization JSONObjectWithData:operation.responseData  options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"得到的数据时:%@",data);
        NSLog(@"得到的报错信息是:%@",error);
        errorBlock(error);
    }];
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
