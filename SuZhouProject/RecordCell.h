//
//  RecordCell.h
//  SuZhouProject
//
//  Created by teddy on 15/10/9.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LongPressButton.h"

@interface RecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *recordImageView;
@property (weak, nonatomic) IBOutlet LongPressButton *recordButton;


@end
