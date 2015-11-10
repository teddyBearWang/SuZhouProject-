//
//  MessageCell.h
//  SuZhouProject
//
//  Created by teddy on 15/11/2.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell
//状态视图
@property (weak, nonatomic) IBOutlet UIView *statueView;
//内容标签
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

- (void)updateCellUI:(NSDictionary *)dict;

@end
