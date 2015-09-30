//
//  TaskCell.h
//  SuZhouProject
//
//  Created by teddy on 15/9/30.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImage;//头图片
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;//区域
@property (weak, nonatomic) IBOutlet UILabel *taskLabel;//任务

//填充内容
- (void)updateCellUI:(NSDictionary *)object_dic;

@end
