//
//  BasicInfoController.m
//  SuZhouProject
//  *********基础信息************
//  Created by teddy on 15/10/29.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "BasicInfoController.h"

@interface BasicInfoController ()

@end

@implementation BasicInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *filterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    filterBtn.frame = (CGRect){0,0,50,30};
    filterBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    filterBtn.layer.borderWidth = 0.3;
    filterBtn.layer.cornerRadius = 5;
    filterBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [filterBtn setTitle:@"筛选" forState:UIControlStateNormal];
    [filterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [filterBtn addTarget:self action:@selector(filterAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *filterItem = [[UIBarButtonItem alloc] initWithCustomView:filterBtn];
    self.navigationItem.rightBarButtonItem = filterItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Action
- (void)filterAction:(UIButton *)btn
{
    [self performSegueWithIdentifier:@"filterBasicInfo" sender:nil];
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    id theSegue = segue.destinationViewController;
//    if ([segue.identifier isEqualToString:@"filterBasicInfo"]) {
//        
//    }
//}

@end
