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
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.contentLabel.text = [dict objectForKey:@"message_content"];
}
@end
