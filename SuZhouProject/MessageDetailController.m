//
//  MessageDetailController.m
//  SuZhouProject
//  ************消息详情***********
//  Created by teddy on 15/11/2.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "MessageDetailController.h"

@interface MessageDetailController ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation MessageDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.bgView.layer.borderWidth = 0.3;
    self.bgView.layer.shadowOpacity = 1;
    self.bgView.clipsToBounds = NO;
    self.bgView.layer.cornerRadius = 5.0;
    self.bgView.layer.shadowOffset = CGSizeMake(0, 3);
    self.bgView.backgroundColor = [UIColor whiteColor];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = (CGRect){0,0,50,30};
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delegate"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteMessageAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:deleteBtn];
    self.navigationItem.rightBarButtonItem = right;
    
    
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.text = @"  2015-10-23 \n  你呗安排了新的巡查任务.巡查地点，太湖南段1.巡查内容：太湖湖面垃圾 \n";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)deleteMessageAction:(UIButton *)button
{
    self.bgView.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
