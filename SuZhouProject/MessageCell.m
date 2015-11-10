//
//  MessageCell.m
//  SuZhouProject
//
//  Created by teddy on 15/11/2.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)updateCellUI:(NSDictionary *)dict
{
    self.contentLabel.numberOfLines = 2;
   // self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.contentLabel.text = [dict objectForKey:@"message_content"];
    //判断1已读，0是未读 状态
    if ([[dict objectForKey:@"flg"] isEqualToString:@"0"]) {
        //未读
        self.statueView.hidden = NO;
    }else{
        //未读
        self.statueView.hidden = YES;
        self.contentLabel.textColor = [UIColor grayColor];
    }
}
@end
