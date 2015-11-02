//
//  CollectionHeaderView.h
//  SuZhouProject
//  ***********基础信息collectionView的headerView**********
//  Created by teddy on 15/10/30.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionHeaderView : UICollectionReusableView

//行政区划
@property (weak, nonatomic) IBOutlet UILabel *arearLabel;
//点击按钮
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
//箭头方向
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;


@end
