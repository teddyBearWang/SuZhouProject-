//
//  CusHeadImageView.h
//  SuZhouProject
//  *********自定义头部视图**********
//  Created by teddy on 15/10/30.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CusHeadImageView : UIView
//背景视图
@property (weak, nonatomic) IBOutlet UIImageView *headBgImageView;
//标签
@property (weak, nonatomic) IBOutlet UILabel *headTitleLabel;



@end
