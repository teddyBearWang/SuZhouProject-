//
//  TaskDelegateCell.h
//  SuZhouProject
//
//  Created by teddy on 15/11/3.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskDelegateCell : UITableViewCell
//区域label
@property (weak, nonatomic) IBOutlet UILabel *postionLabel;
//任务类型
@property (weak, nonatomic) IBOutlet UILabel *taskTypeLabel;
//委托按钮
@property (weak, nonatomic) IBOutlet UIButton *delegateButton;

- (void)updateCell:(NSDictionary *)dict;

@end
