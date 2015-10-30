//
//  FilterCollectionCell.m
//  SuZhouProject
//
//  Created by teddy on 15/10/30.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "FilterCollectionCell.h"

@implementation FilterCollectionCell

- (void)updateNameLabelWithText:(NSString *)name
{
    self.nameLabel.text = name;
    self.layer.cornerRadius = 5.0;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 0.3;
}

@end
