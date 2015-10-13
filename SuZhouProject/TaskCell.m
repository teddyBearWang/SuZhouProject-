//
//  TaskCell.m
//  SuZhouProject
//
//  Created by teddy on 15/9/30.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "TaskCell.h"

@implementation TaskCell

- (void)awakeFromNib {
    // Initialization code
}

//填充内容
- (void)updateCellUI:(NSDictionary *)object_dic
{
    self.positionLabel.text = [object_dic objectForKey:@"taskname"];
    self.taskLabel.text = [object_dic objectForKey:@"content"];
    NSString *state = [object_dic objectForKey:@"state"];
    if ([state isEqualToString:@"未巡查"])
    {
        self.headImage.image = [UIImage imageNamed:@"status_none"];
    }
    else if ([state isEqualToString:@"正在巡查"])
    {
        self.headImage.image = [UIImage imageNamed:@"status_doing"];
    }
    else if ([state isEqualToString:@"已完成"])
    {
        self.headImage.image = [UIImage imageNamed:@"status_ok"];
    }
}

@end
