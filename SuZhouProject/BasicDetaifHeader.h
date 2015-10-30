//
//  BasicDetaifHeader.h
//  SuZhouProject
//  **********基础信息的headerView*********
//  Created by teddy on 15/10/30.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasicDetaifHeader : UIView
//河流等级
@property (weak, nonatomic) IBOutlet UILabel *riverLevelLabel;
//第一张图片
@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;
//第一个标签
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
//第二张图片
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;
//第二个标签
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@end
