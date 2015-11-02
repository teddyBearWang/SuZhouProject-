//
//  ChangeReusableView.h
//  SuZhouProject
//  *******************
//  Created by teddy on 15/11/2.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeReusableView : UICollectionReusableView
//类型标签
@property (weak, nonatomic) IBOutlet UILabel *TypeLabel;
//点击按钮
@property (weak, nonatomic) IBOutlet UIButton *valueButton;

@end
