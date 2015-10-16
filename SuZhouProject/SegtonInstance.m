//
//  SegtonInstance.m
//  SuZhouProject
//
//  Created by teddy on 15/10/15.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "SegtonInstance.h"

@implementation SegtonInstance

+ (SegtonInstance *)shareInstance
{
    static SegtonInstance *instance = nil;
   static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[SegtonInstance alloc] init];
        }
    });
    return instance;
}

@end
