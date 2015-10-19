//
//  UserLocation.h
//  SuZhouProject
//  **********用户的位置信息****************
//  Created by teddy on 15/10/19.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserLocation : NSObject
{
    float _userLat;
    float _userLng;
}

@property (nonatomic) float userLat;//纬度

@property (nonatomic) float userLng;//精度

@end
