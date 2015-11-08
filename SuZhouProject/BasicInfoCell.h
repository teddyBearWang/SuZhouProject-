//
//  BasicInfoCell.h
//  SuZhouProject
//  ***********基础信息cell*************
//  Created by teddy on 15/10/30.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasicInfoCell : UITableViewCell
//名字标签
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//长度图片
@property (weak, nonatomic) IBOutlet UIImageView *lengthImage;
//长度标签
@property (weak, nonatomic) IBOutlet UILabel *lengthLabel;
//面积图片
@property (weak, nonatomic) IBOutlet UIImageView *areaImage;
//面积标签
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;

@property (assign) BOOL _isPond;//是否为塘坝

//给cell赋值
- (void)updateCellWith:(NSDictionary *)dict;

@end
