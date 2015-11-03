//
//  PersonInfoCell.h
//  SuZhouProject
//
//  Created by teddy on 15/11/3.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *postionLabel;

@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

- (void)updateCellContent:(NSDictionary *)dict;
@end
