//
//  UploadViewController.m
//  SuZhouProject
//
//  Created by teddy on 15/10/8.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "UploadViewController.h"
#import "RecordCell.h"

@interface UploadViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSString *_recordInfo;//录音信息，“录音2015-09-10 08:32:35”
    BOOL _isRecorded;//是否已经录过音
    BOOL _isRecording;//是否正在进行录音
    NSTimer *timer; //定时器
}
@property (weak, nonatomic) IBOutlet UITableView *detailTable;

//确认上报
- (IBAction)comfirnUploadAction:(id)sender;

//点击背景取消
- (IBAction)tapBackgroundAction:(id)sender;
@end

@implementation UploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.detailTable.delegate = self;
    self.detailTable.dataSource = self;
    self.detailTable.scrollEnabled = NO;//禁止滚动
    self.view.backgroundColor = [UIColor greenColor];
    
    _recordInfo = @"请按住进行录音";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        if ([self.detailTable respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.detailTable setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
    }
#endif
    
    if ([self.detailTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.detailTable setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
}


//确认上传
- (IBAction)comfirnUploadAction:(id)sender
{
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = @"水域变化";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"list"];
        return cell;
    }else{
        switch (indexPath.row) {
            case 0:
            {
                UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                UITextField *textField= [[UITextField alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
                textField.borderStyle = UITextBorderStyleNone;
                textField.placeholder = @"输入问题描述...";
                textField.delegate = self;
               // textField.returnKeyType = UIReturnKeyDone;
                textField.font = [UIFont systemFontOfSize:14];
                textField.tag = 101;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.contentView addSubview:textField];
                return cell;
            }
                break;
            case 1:
            {
                RecordCell *cell = (RecordCell *)[[[NSBundle mainBundle] loadNibNamed:@"RecordCell" owner:nil options:nil] lastObject];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.tag = 102;
                [cell.recordButton setTitle:@"请按住进行录音" forState:UIControlStateNormal];
                if (!_isRecorded) {
                    //未录音
                    //文字居中对齐
                    [cell.recordButton setTextAlignment:@"center"];
                }else{
                    //已经录音
                    //文字左对齐
                    [cell.recordButton setTextAlignment:@"left"];
                }
                //按住按钮不松开
                [cell.recordButton addTarget:self action:@selector(buttonLongPress) forControlEvents:ControlEventTouchLongPress];
                //松开按钮
               [cell.recordButton addTarget:self action:@selector(cancelLongPress) forControlEvents:ControlEventTouchCancel];
                return cell;
            }
                break;
            default:
                return nil;
                break;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 44;
    }else{
        switch (indexPath.row) {
            case 0:
                return 100;
                break;
            case 1:
                return 44;
                break;
            default:
                return 0;
                break;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *header = [[UIView alloc] initWithFrame:(CGRect){0,0,kScreenWidth,1}];
        return header;
    }else{
        UIView *header = [[UIView alloc] initWithFrame:(CGRect){0,0,kScreenWidth,20}];
        return header;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return 20;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
    }
#endif
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        [self performSegueWithIdentifier:@"changeType" sender:nil];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Record Active
//按下录音，开始录音
- (void)buttonLongPress
{
    NSLog(@"开始录音");
    timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(detectionVoice) userInfo:nil repeats:YES];
}

//根据音量刷新图片
- (void)detectionVoice
{
    if (!_isRecording) {
        _isRecording = YES;
    }
    NSLog(@"正在录音");
}

//录音结束
- (void)cancelLongPress
{
    if (_isRecording) {
        [timer invalidate];
        _isRecording = NO;
    }
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//点击背景取消
- (IBAction)tapBackgroundAction:(id)sender
{
    UITextField *textField = (UITextField *)[self.view viewWithTag:101];
    [textField resignFirstResponder];
}

@end
