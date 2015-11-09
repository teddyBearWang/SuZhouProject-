//
//  FilterBasicInfoController.m
//  SuZhouProject
//  **********基础信息的筛选控制器**************
//  Created by teddy on 15/10/29.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "FilterBasicInfoController.h"
#import "FilterCollectionCell.h"
#import "CollectionHeaderView.h"

@interface FilterBasicInfoController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITextViewDelegate>
{
    NSArray *_list1;//数据源
    NSArray *_list2;//数据源
    NSString *_selectArea;//选择的地区
    NSString *_selectLevel;//选择等级
    NSInteger _sectionOneCount;//section0的row数量，因为是可变的
    
}
//条件collectionView
@property (weak, nonatomic) IBOutlet UICollectionView *filterCollectionView;
//水域面积
@property (weak, nonatomic) IBOutlet UILabel *waterAreaLabel;
//第一个textField
@property (weak, nonatomic) IBOutlet UITextField *firstTextField;
//第二个textField
@property (weak, nonatomic) IBOutlet UITextField *secondTextField;
//河流名称
@property (weak, nonatomic) IBOutlet UILabel *rivilerNameLabel;
//河流名称textField
@property (weak, nonatomic) IBOutlet UITextField *riverNameTextField;
//查询button
@property (weak, nonatomic) IBOutlet UIButton *queryButton;
//查询事件
- (IBAction)queryInfoAction:(id)sender;

//点击背景取消键盘
- (IBAction)tapBackground:(id)sender;

@end

@implementation FilterBasicInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getwebData];
    
    self.filterCollectionView.delegate = self;
    self.filterCollectionView.dataSource = self;
    self.filterCollectionView.backgroundColor = BG_COLOR;
    //self.view.backgroundColor = [UIColor yellowColor];
    
   // _list1 = @[@"全市",@"相城区",@"吴中区",@"虎丘区",@"姑苏区",@"相城区",@"吴中区",@"虎丘区",@"太仓市"];
    
   // _list2 = @[@"全部",@"省级",@"市管",@"县级",@"乡镇级"];
    
    //必须注册nib类
    [self.filterCollectionView registerNib:[UINib nibWithNibName:@"FilterCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"filterIdentifier"];
    
    UICollectionViewFlowLayout *collectionViewLayout = (UICollectionViewFlowLayout *)self.filterCollectionView.collectionViewLayout;
    collectionViewLayout.sectionInset = UIEdgeInsetsMake(0, 0, 20, 0);
    
    //键盘即将出现
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillHideNotification object:nil];
    
    //键盘即将消失
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - getWebData

/*
 *获取筛选条件
 */
- (void)getwebData
{
    [SVProgressHUD show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [RequestHttps fetchWithType:@"GetParam" Results:self.requestParameter completion:^(NSArray *datas) {
            //成功
            if (datas.count == 0) {
                [SVProgressHUD dismissWithError:@"数据为空"];
            }else{
                [SVProgressHUD dismissWithSuccess:nil];
                NSDictionary *dict = datas[0];
                _list1 = [dict objectForKey:@"region"];
                if (![self.filterType isEqualToString:@"塘坝等级"]) {
                    //含有等级筛选条件
                    NSArray *list = [self.requestParameter componentsSeparatedByString:@"$"];
                    _list2 = [dict objectForKey:[list lastObject]];//数据源赋值

                }
                [self.filterCollectionView reloadData];
                //初始化
                _selectArea = [_list1[0] objectForKey:@"value"];
                _selectLevel = [_list2[0] objectForKey:@"value"];
            }
        } error:^(NSError *error) {
            //失败
            [SVProgressHUD dismissWithError:@"加载失败"];
        }];
    });
}

#pragma mark - NSNotification
//键盘即将出现
- (void)keyboardWillShow:(NSNotification *)notification
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    self.view.center = CGPointMake(self.view.center.x, self.view.center.y+50);
    [UIView commitAnimations];
}

//键盘即将消失
- (void)keyboardWillHide:(NSNotification *)notification
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    self.view.center = CGPointMake(self.view.center.x, self.view.center.y-50);
    [UIView commitAnimations];
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (_list2.count == 0) {
        return 1;
    }else{
        return 2;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return _list1.count;
        }
            break;
        case 1:
        {
            return _list2.count;
        }
            break;
        default:
        {
            return 0;
        }
            break;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FilterCollectionCell *filterCell = (FilterCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"filterIdentifier" forIndexPath:indexPath];
    filterCell.backgroundColor = BG_COLOR;
    switch (indexPath.section) {
        case 0:
        {
            NSDictionary *dict = _list1[indexPath.row];
            [filterCell updateNameLabelWithText:[dict objectForKey:@"value"]];
            if (indexPath.row == _oldAreaIndex) {
                filterCell.backgroundColor = [UIColor orangeColor];
            }
        }
            break;
        case 1:
        {
            NSDictionary *dict = _list2[indexPath.row];
            [filterCell updateNameLabelWithText:[dict objectForKey:@"value"]];
            if (indexPath.row == _oldSelectLevelIndex) {
                filterCell.backgroundColor = [UIColor orangeColor];
            }
        }
            break;
        default:
            break;
    }
    return filterCell;
}

//实现sectionHeader
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *resuableView = nil;
    //表示headerVIew
    if (kind == UICollectionElementKindSectionHeader) {
        CollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerVIewIdentifier" forIndexPath:indexPath];
        if (indexPath.section == 0) {
            //section 0
            headerView.arearLabel.text = @"行政区划";
            headerView.selectButton.hidden = YES;
            headerView.arrowImageView.hidden = YES;
            [headerView.selectButton setTitle:_selectArea forState:UIControlStateNormal];
            //关于展开的代码
            //[headerView.selectButton addTarget:self action:@selector(selectRivierAreaAction:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            //section 1
            headerView.arearLabel.text = self.filterType;
            headerView.selectButton.hidden = YES;
            headerView.arrowImageView.hidden = YES;
        }
        resuableView = headerView;
    }
    return resuableView;;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(70, 30);
}

static NSInteger _oldSelectLevelIndex;//上一次选择 等级
static NSInteger _oldAreaIndex;//上一次选择 地区
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            //选择的区域
             _selectArea = [_list1[indexPath.row] objectForKey:@"value"];
            NSIndexPath *oldIndex = [NSIndexPath indexPathForItem:_oldAreaIndex inSection:0];
            //上一次选择的cell
            FilterCollectionCell *oldCell = (FilterCollectionCell *)[collectionView cellForItemAtIndexPath:oldIndex];
            oldCell.backgroundColor = BG_COLOR;//设置成原来的颜色
            //等级选择
            FilterCollectionCell *filterCell = (FilterCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
            filterCell.backgroundColor = [UIColor orangeColor];
            _oldAreaIndex = indexPath.row;
            //关于展开的代码
            /*
            _sectionOneCount = 0;
            [self.filterCollectionView reloadData];
             */
        }
            break;
        case 1:
        {
            //选择的等级
            _selectLevel = [_list2[indexPath.row] objectForKey:@"value"];
            NSIndexPath *oldIndex = [NSIndexPath indexPathForItem:_oldSelectLevelIndex inSection:1];
            //上一次选择的cell
             FilterCollectionCell *oldCell = (FilterCollectionCell *)[collectionView cellForItemAtIndexPath:oldIndex];
            oldCell.backgroundColor = BG_COLOR;//设置成原来的颜色
            //等级选择
            FilterCollectionCell *filterCell = (FilterCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
            filterCell.backgroundColor = [UIColor orangeColor];
            _oldSelectLevelIndex = indexPath.row;
            
        }
            break;
        default:
            break;
    }
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark - Private Action
//关于展开的代码
//- (void)selectRivierAreaAction:(UIButton *)button
//{
//    _sectionOneCount = _list1.count; //关于展开的代码
//    [self.filterCollectionView reloadData];
//   // self.filterCollectionView.contentSize.height;
//    NSLog(@"collectionView 的内容高度：%lf",self.filterCollectionView.contentSize.height);
//}

//查询
- (IBAction)queryInfoAction:(id)sender
{
    NSLog(@"查询数据");
    //传递选择参数
    [self.delegate passFilterValue:_selectArea riverLevel:_selectLevel startArea:self.firstTextField.text endArea:self.secondTextField.text name:self.riverNameTextField.text];
    [self.navigationController popViewControllerAnimated:YES];
}

//点击背景取消键盘
- (IBAction)tapBackground:(id)sender
{
    [self.firstTextField resignFirstResponder];
    [self.secondTextField resignFirstResponder];
    [self.riverNameTextField resignFirstResponder];
}
@end
