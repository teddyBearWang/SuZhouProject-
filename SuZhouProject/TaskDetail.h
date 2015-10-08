//
//  TaskDetail.h
//  SuZhouProject
//
//  Created by teddy on 15/10/8.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskDetail : UITableViewCell
//标题label
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
//中间的分隔符
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
//后面的内容
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
//显示地图详情的button
@property (weak, nonatomic) IBOutlet UIButton *postionButton;

@end
