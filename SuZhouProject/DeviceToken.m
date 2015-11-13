//
//  DeviceToken.m
//  SuZhouProject
//
//  Created by teddy on 15/11/11.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "DeviceToken.h"

@implementation DeviceToken


/*
 *获取设备的vendor码，同一个公司所有的app在同一台设备上是相同的一个vendor码，
 *不同的设备上的vendor码是不相同的
 */
+ (NSString *)deviceVendor;
{
   // NSArray *results = getValue(@"device-imei");
    NSString *vendorStr = [[UIDevice currentDevice].identifierForVendor  UUIDString];
    
    return vendorStr;
}

@end
