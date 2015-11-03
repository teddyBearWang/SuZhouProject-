//
//  TaskDelegateCell.m
//  SuZhouProject
//
//  Created by teddy on 15/11/3.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "TaskDelegateCell.h"

@implementation TaskDelegateCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)updateCell:(NSDictionary *)dict
{
    self.delegateButton.layer.cornerRadius = 5;
    self.delegateButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.delegateButton.layer.borderWidth = 0.3;
}

@end
