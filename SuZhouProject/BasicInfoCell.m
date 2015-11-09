//
//  BasicInfoCell.m
//  SuZhouProject
//
//  Created by teddy on 15/10/30.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "BasicInfoCell.h"

////名字标签
//@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
////长度图片
//@property (weak, nonatomic) IBOutlet UIImageView *lengthImage;
////长度标签
//@property (weak, nonatomic) IBOutlet UILabel *lengthLabel;
////面积图片
//@property (weak, nonatomic) IBOutlet UIImageView *areaImage;
////面积标签
//@property (weak, nonatomic) IBOutlet UILabel *areaLabel;

@implementation BasicInfoCell

- (void)awakeFromNib {
    // Initialization code
}

//给cell赋值
- (void)updateCellWith:(NSDictionary *)dict
{
    if (self._isPond) {
        //塘坝
        self.nameLabel.text = [dict objectForKey:@"name"];
        self.lengthLabel.text = [NSString stringWithFormat:@"面积:%@ ㎡",[dict objectForKey:@"area"]];
        //塘坝没有长度，所以将长度隐藏s
        self.areaLabel.hidden = YES;
        self.areaImage.hidden = YES;
    }else{
        //水库、河道
        self.nameLabel.text = [dict objectForKey:@"name"];
        self.lengthLabel.text = [NSString stringWithFormat:@"长度:%@ km",[dict objectForKey:@"length"]];
        self.areaLabel.text = [NSString stringWithFormat:@"面积:%@ ㎡",[dict objectForKey:@"area"]];
    }
}

@end
