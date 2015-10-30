//
//  FilterCollectionCell.h
//  SuZhouProject
//  ***********筛选条件cell**************
//  Created by teddy on 15/10/30.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterCollectionCell : UICollectionViewCell
//名字标签
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

- (void)updateNameLabelWithText:(NSString *)name;

@end
