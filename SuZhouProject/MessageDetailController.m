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
    deleteBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    deleteBtn.layer.borderWidth = 0.3;
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
   // [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delegate"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteMessageAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:deleteBtn];
    self.navigationItem.rightBarButtonItem = right;
    
    
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.text = [self.passParameter objectForKey:@"message_content"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)deleteMessageAction:(UIButton *)button
{
    //self.bgView.hidden = YES;
//    
//    NSUserDefaults *users = [NSUserDefaults standardUserDefaults];
//    NSDictionary *userDict = [users objectForKey:@"UserInfo"];
    [SVProgressHUD showWithStatus:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [RequestHttps fetchWithType:@"DelMessage" Results:[self.passParameter objectForKey:@"id"] completion:^(NSArray *datas) {
            //成功
            if (datas.count == 0) {
                [SVProgressHUD dismissWithError:@"删除失败"];
                return;
            }
            if ([[datas[0] objectForKey:@"success"] isEqualToString:@"True"]) {
                [SVProgressHUD dismissWithSuccess:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [SVProgressHUD dismissWithError:@"删除失败"];
            }
        } error:^(NSError *error) {
            //失败
            [SVProgressHUD dismissWithError:@"删除失败"];
        }];
    });
}

@end
