//
//  ChangeDetaiHeader.h
//  SuZhouProject
//
//  Created by teddy on 15/11/2.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeDetaiHeader : UIView

//位置label
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
//类型图片
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
//变化详情
@property (weak, nonatomic) IBOutlet UILabel *changeDetaiLabel;
@end
