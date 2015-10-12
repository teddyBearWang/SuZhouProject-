//
//  UploadViewController.m
//  SuZhouProject
//  **********巡查上报**************
//  Created by teddy on 15/10/8.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "UploadViewController.h"
#import "RecordCell.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

#import "CBProfilePhotoViewCell.h"

#import "ELCImagePickerHeader.h"
#import <MobileCoreServices/UTCoreTypes.h>


//语音视图的高度
#define RecordImageViewHeight 75
//语音视图的宽度
#define RecordImageViewWidth 50
@interface UploadViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,ELCImagePickerControllerDelegate>
{
    NSString *_recordInfo;//录音信息，“录音2015-09-10 08:32:35”
    BOOL _isRecording;//是否正在进行录音
    BOOL _isRecorded;//是否已经录过音
    NSTimer *timer; //定时器
    AVAudioRecorder *_recorder;//录音对象
    NSString *_existRecordFileUrl;//存在录音文件的地址
    
    UIImageView *_voiceImageView;//显示音量的图片视图
    
    NSMutableArray *_images;//collectionViews的数据源
    
    AVPlayer *_play;//播放
}
//详细列表
@property (weak, nonatomic) IBOutlet UITableView *detailTable;

//显示图片
@property (weak, nonatomic) IBOutlet UICollectionView *imagesCollection;


//确认上报
- (IBAction)comfirnUploadAction:(id)sender;

//点击背景取消
- (IBAction)tapBackgroundAction:(id)sender;
@end

@implementation UploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //详细列表的数据源和代理
    self.detailTable.delegate = self;
    self.detailTable.dataSource = self;
    self.detailTable.scrollEnabled = NO;//禁止滚动
    self.view.backgroundColor = [UIColor greenColor];
    
    //图片模块的数据源和代理
    self.imagesCollection.dataSource = self;
    self.imagesCollection.delegate = self;
    self.imagesCollection.scrollEnabled = NO;
    self.imagesCollection.backgroundColor = BG_COLOR;
    
    _voiceImageView = [[UIImageView alloc] initWithFrame:(CGRect){(kScreenWidth - RecordImageViewWidth)/2,RecordImageViewWidth,RecordImageViewWidth,RecordImageViewHeight}];
    _voiceImageView.alpha = 0.8;
    _voiceImageView.hidden = YES;//显示隐藏
    [self.view addSubview:_voiceImageView];
    
    _images = [NSMutableArray arrayWithObject:[UIImage imageNamed:@"plus"]];
    
    //录音准备
    [self audioPrepare];

    _recordInfo = @"请按住进行录音";
    //必须在viewDidLoad中加载这个方法，如果不声明，将无法加载，程序崩溃
    //如果自定义的cell是有xib文件的，那么就应该用这个方法
    [self.imagesCollection registerNib:[UINib nibWithNibName:@"PhotoCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"photo"];

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
                textField.returnKeyType = UIReturnKeyDone;
                textField.font = [UIFont systemFontOfSize:14];
                textField.tag = 101;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.contentView addSubview:textField];
                return cell;
            }
                break;
            case 1:
            {
                RecordCell *cell = (RecordCell *)[[[NSBundle mainBundle] loadNibNamed:@"RecordCell" owner:self options:nil] lastObject];
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                cell.tag = 102;
                if (!_isRecorded) {
                    //没有录过音
                   // cell.textLabel.textAlignment = NSTextAlignmentCenter;
                    cell.tapButton.titleLabel.textAlignment = NSTextAlignmentCenter;
                }else{
                    //录过音
                  //  cell.textLabel.textAlignment = NSTextAlignmentLeft;
                    cell.tapButton.titleLabel.textAlignment = NSTextAlignmentLeft;
                    cell.recordImageView.image = [UIImage imageNamed:@"voice"];
                }
                cell.tapButton.tag = 103;
                [cell.tapButton setTitle:_recordInfo forState:UIControlStateNormal] ;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
                [cell.tapButton addGestureRecognizer:tap];
                
                UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(buttonLongPress:)];
                longPress.minimumPressDuration = 0.5;
                [cell.tapButton addGestureRecognizer:longPress];
                
                //当longPress手势不触发的时候，才会触发tap手势
                [tap requireGestureRecognizerToFail:longPress];
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
//单机手势
- (void)tapAction:(UIGestureRecognizer *)gesture
{
    NSLog(@"播放");
    NSURL *filePath = [NSURL fileURLWithPath:_existRecordFileUrl];
    _play = [[AVPlayer alloc] initWithURL:filePath];
    _play.volume = 4;
    [_play play];
}

//按下录音，开始录音
- (void)buttonLongPress:(UIGestureRecognizer *)gesture
{
    //手势开始
    if (gesture.state == UIGestureRecognizerStateBegan) {
        if ([self isExist]) {
            //录音文件存在，则需要先删除
            [_recorder deleteRecording];
        }
        if ([_recorder prepareToRecord]) {
            NSLog(@"开始录音");
            _recordInfo = [NSString stringWithFormat:@"录音文件 %@",[self getCurrentTime]];
            [_recorder record];//开始录音
        }
        timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(detectionVoice) userInfo:nil repeats:YES];
    }else if (gesture.state == UIGestureRecognizerStateEnded){
        //手势结束
        if (_isRecording) {
            //结束录音
            [_recorder stop];
            [timer invalidate];
            _isRecording = NO;
        }
        _voiceImageView.hidden = YES;//隐藏图片
        _isRecorded = YES;//录过音
        [self.detailTable reloadData];
        NSLog(@"结束录音");
    }
}

//录音文件是否存在
- (BOOL)isExist
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:_existRecordFileUrl]) {
        return YES;
    }else{
        return NO;
    }
}

//录音配置
- (void)audioPrepare
{
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    //设置录音格式，AVFormatIDKey==kAudioFormatLinearPCM
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    //设置采样频率(HZ), AVSampleRateKey==8000/44100/96000(影响音频质量)
    [recordSetting setValue:[NSNumber numberWithFloat:44100] forKey:AVSampleRateKey];
    //设置录音通道数 1或2
    [recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    //设置采样位数 8、16、24、32
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //录音质量
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    
    NSError *error;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    [session setActive:YES error:&error];
    
    //获取document文件的录音
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //录音文件的路径
    _existRecordFileUrl = [NSString stringWithFormat:@"%@/%@.aac",filePath,[self getCurrentTime]];
    NSURL *fileUrl = [NSURL fileURLWithPath:_existRecordFileUrl];
    //更新录音button的文字
    
    _recorder = [[AVAudioRecorder alloc] initWithURL:fileUrl settings:recordSetting error:&error];
    //开启音量监测
    _recorder.meteringEnabled = YES;
    //_recorder.delegate = self;
}

//获取当前录音时刻的时间
- (NSString *)getCurrentTime
{
    NSDate *now = [NSDate date];
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    NSString *currentTimeStr = [formater stringFromDate:now];
    return currentTimeStr;
}

//根据音量刷新图片
- (void)detectionVoice
{
    
    if (!_isRecording) {
        _isRecording = YES;
        _voiceImageView.hidden = NO;//将图片显示出来
    }
    UIButton *button = (UIButton *)[self.view viewWithTag:103];
    [button setTitle:@"正在录音" forState:UIControlStateHighlighted];
    NSLog(@"正在录音-----------");
    [_recorder updateMeters];//刷新音量数据
    //获取音量的平均值  [recorder averagePowerForChannel:0];
    //音量的最大值  [recorder peakPowerForChannel:0];
    
    double lowPassResults = pow(10, (0.05 * [_recorder peakPowerForChannel:0]));
    NSLog(@"%lf",lowPassResults);
    //最大50  0
    //图片 小-》大
    if (0<lowPassResults<=0.06) {
        [_voiceImageView setImage:[UIImage imageNamed:@"record_animate_01.png"]];
    }else if (0.06<lowPassResults<=0.13) {
        [_voiceImageView setImage:[UIImage imageNamed:@"record_animate_02.png"]];
    }else if (0.13<lowPassResults<=0.20) {
        [_voiceImageView setImage:[UIImage imageNamed:@"record_animate_03.png"]];
    }else if (0.20<lowPassResults<=0.27) {
        [_voiceImageView setImage:[UIImage imageNamed:@"record_animate_04.png"]];
    }else if (0.27<lowPassResults<=0.34) {
        [_voiceImageView setImage:[UIImage imageNamed:@"record_animate_05.png"]];
    }else if (0.34<lowPassResults<=0.41) {
        [_voiceImageView setImage:[UIImage imageNamed:@"record_animate_06.png"]];
    }else if (0.41<lowPassResults<=0.48) {
        [_voiceImageView setImage:[UIImage imageNamed:@"record_animate_07.png"]];
    }else if (0.48<lowPassResults<=0.55) {
        [_voiceImageView setImage:[UIImage imageNamed:@"record_animate_08.png"]];
    }else if (0.55<lowPassResults<=0.62) {
        [_voiceImageView setImage:[UIImage imageNamed:@"record_animate_09.png"]];
    }else if (0.62<lowPassResults<=0.69) {
        [_voiceImageView setImage:[UIImage imageNamed:@"record_animate_10.png"]];
    }else if (0.69<lowPassResults<=0.76) {
        [_voiceImageView setImage:[UIImage imageNamed:@"record_animate_11.png"]];
    }else if (0.76<lowPassResults<=0.83) {
        [_voiceImageView setImage:[UIImage imageNamed:@"record_animate_12.png"]];
    }else if (0.83<lowPassResults<=0.9) {
        [_voiceImageView setImage:[UIImage imageNamed:@"record_animate_13.png"]];
    }else {
        [_voiceImageView setImage:[UIImage imageNamed:@"record_animate_14.png"]];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CBProfilePhotoViewCell *myCell = (CBProfilePhotoViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"photo" forIndexPath:indexPath];
    
    myCell.profileImageView.image = _images[indexPath.row];
    myCell.profileImageView.contentMode = UIViewContentModeScaleAspectFit;
    myCell.profileImageView.tag = [indexPath row];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapProfileImage:)];
    singleTap.numberOfTapsRequired = 1;
    myCell.profileImageView.userInteractionEnabled = YES;
    [myCell.profileImageView  addGestureRecognizer:singleTap];
    
    myCell.closeBtn.tag = [indexPath row];
    
    //if ([indexPath row] == (_images.count - 1)){
    //隐藏删除按钮
        [myCell.closeBtn setHidden:YES];
    //}
    [myCell.closeBtn addTarget:self action:@selector(deletePhoto:)
                 forControlEvents:UIControlEventTouchUpInside];
    return myCell;

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80, 80);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 8, 10, 8);
}

#pragma mark - delegate image Action
//添加图片
- (void)tapProfileImage:(UIGestureRecognizer *)gesture
{
    UIImageView *tableGridImage = (UIImageView*)gesture.view;
    NSInteger index = tableGridImage.tag;
    //点击了“+”号
    if (index == _images.count - 1) {
        //添加图片
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
        [actionSheet showInView:self.view];
    }
}

//删除图片
- (void)deletePhoto:(UIButton *)button
{
    [_images removeObjectAtIndex:button.tag];
    [self.imagesCollection reloadData];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            //拍照
            [self ClickTakePhotoAction:nil];
            break;
        case 1:
            //从相册中选择
            [self chooseImages];
            break;
        default:
            break;
    }
}


#pragma mark - take Photos Action
//判断设备是否有摄像头
- (BOOL)isCaremaAviable
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

//判断后置摄像头是否可用
- (BOOL)isRearCaremaAviable
{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (void)ClickTakePhotoAction:(id)sender
{
    //判断有摄像头并且支持拍照
    if ([self isCaremaAviable] && [self isRearCaremaAviable]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        //设置拍照类型
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        controller.allowsEditing = YES;//允许编辑
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }
}

#pragma - UIImagePickerControllerDelegate
// 当用户取消时，调用该方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//拍照后得到该方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0)
{
    NSLog(@"拍照成功");
    [_images insertObject:image atIndex:(_images.count - 1)];
    [picker dismissViewControllerAnimated:YES completion:^{
        //刷新列表
        [self.imagesCollection reloadData];
    }];
    
}

#pragma mark - Choose Images from Library
//从相册中选择图片
- (void)chooseImages
{
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
    //允许选择的最多张图片
    elcPicker.maximumImagesCount = 4;
    //返回源照片
    elcPicker.returnsOriginalImage = YES;
    elcPicker.returnsImage = YES;
    //按照选择顺序
    elcPicker.onOrder = YES;
    //只允许选择照片
    elcPicker.mediaTypes = @[(NSString *)kUTTypeImage];
    elcPicker.imagePickerDelegate = self;
    
    [self presentViewController:elcPicker animated:YES completion:nil];
}

#pragma mark ELCImagePickerControllerDelegate Methods
- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:[info count]];
    //遍历数组，取出相应的图片
    for (NSDictionary *dict in info) {
        //如果取出来的是照片
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto) {
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]) {
                UIImage *image = [dict objectForKey:UIImagePickerControllerOriginalImage];
                [images addObject:image];
            }
        }
    }
    //刷新界面
    [self dismissViewControllerAnimated:YES completion:^{
        for (UIImage *image in images) {
            [_images insertObject:image atIndex:(_images.count -1)];
        }
        [self.imagesCollection reloadData];
    }];
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
