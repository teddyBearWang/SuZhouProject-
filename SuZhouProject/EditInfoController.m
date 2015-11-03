//
//  EditInfoController.m
//  SuZhouProject
//  ********信息编辑界面***********
//  Created by teddy on 15/11/3.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "EditInfoController.h"

@interface EditInfoController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *keyLabel;
@property (weak, nonatomic) IBOutlet UITextField *valueField;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

- (IBAction)confirmAction:(id)sender;

//点击背景
- (IBAction)tabBackground:(id)sender;
@end

@implementation EditInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.confirmButton.layer.cornerRadius = 6;
    self.valueField.delegate = self;
    
    self.title = self.passKey;
    self.keyLabel.text = self.passKey;
    
    self.valueField.placeholder = self.passvalue;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        [self.valueField resignFirstResponder];
    }
    return YES;
}

//确认上传
- (IBAction)confirmAction:(id)sender {
}

//点击背景
- (IBAction)tabBackground:(id)sender
{
    [self.valueField resignFirstResponder];
}
@end
