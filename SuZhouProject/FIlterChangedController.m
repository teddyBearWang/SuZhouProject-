//
//  FIlterChangedController.m
//  SuZhouProject
//  *********变化信息筛选界面**********
//  Created by teddy on 15/10/29.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "FIlterChangedController.h"
#import "FilterCollectionCell.h"
#import "ChangeReusableView.h"

@interface FIlterChangedController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITextViewDelegate>
{
    NSArray *_list1;//数据源
    NSArray *_list2;//数据源
    NSArray *_list3;//数据源
    NSArray *_list4;//数据源
    NSArray *_list5;//数据源
    NSString *_selectArea;//选择的地区
    NSString *_selectBeforeType;//选择的变化前类型
    NSString *_selectAfterType;//选择的变化后的类型
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
//水域名称
@property (weak, nonatomic) IBOutlet UILabel *watersNameLabel;
//水域名称textField
@property (weak, nonatomic) IBOutlet UITextField *watersNameTextField;
//查询button
@property (weak, nonatomic) IBOutlet UIButton *queryButton;
//查询事件
- (IBAction)queryInfoAction:(id)sender;

//点击背景取消键盘
- (IBAction)tapBackground:(id)sender;
@end

@implementation FIlterChangedController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.title = self.filterType;
    
    _list1 = @[@"全市",@"相城区",@"吴中区",@"虎丘区",@"姑苏区",@"相城区",@"吴中区",@"虎丘区",@"太仓市"];
    
    _list2 = @[@"全部",@"市管河道",@"市管湖泊"];
    
    _list3 = @[@"河流",@"湖泊",@"池塘",@"山塘",@"河流",@"湖泊",@"池塘",@"山塘",@"河流",@"湖泊",@"池塘",@"山塘"];
    _list4 = _list3;
    _list5 = @[@"全部",@"合理",@"有疑议",@"维护变化"];
    
    _selectArea = @"全部";
    _selectBeforeType = @"林地";
    _selectAfterType = @"池塘";
    _sectionOneCount = _list1.count;
    
    self.filterCollectionView.delegate = self;
    self.filterCollectionView.dataSource = self;
    //必须注册nib类
    [self.filterCollectionView registerNib:[UINib nibWithNibName:@"FilterCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"filterIdentifier"];
    
    UICollectionViewFlowLayout *collectionViewLayout = (UICollectionViewFlowLayout *)self.filterCollectionView.collectionViewLayout;
    collectionViewLayout.sectionInset = UIEdgeInsetsMake(0, 0, 20, 0);
     collectionViewLayout.headerReferenceSize = CGSizeMake(320, 50);
    
    //键盘即将出现
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillHideNotification object:nil];
    
    //键盘即将消失
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillShowNotification object:nil];
}

#pragma mark - NSNotification
//键盘即将出现
- (void)keyboardWillShow:(NSNotification *)notification
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    self.view.center = CGPointMake(self.view.center.x, self.view.center.y+150);
    [UIView commitAnimations];
}

//键盘即将消失
- (void)keyboardWillHide:(NSNotification *)notification
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    self.view.center = CGPointMake(self.view.center.x, self.view.center.y-150);
    [UIView commitAnimations];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 5;
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
        case 2:
        {
            return _list3.count;
        }
            break;
        case 3:
        {
            return _list4.count;
        }
            break;
        case 4:
        {
            return _list5.count;
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
//    FilterCollectionCell *filterCell = (FilterCollectionCell *)[[[NSBundle mainBundle] loadNibNamed:@"FilterCell" owner:nil options:nil] lastObject];
    filterCell.backgroundColor = BG_COLOR;
    switch (indexPath.section) {
        case 0:
        {
            //行政区划
            [filterCell updateNameLabelWithText:_list1[indexPath.row]];
            if (indexPath.row == _oldAreaIndex) {
                filterCell.backgroundColor = [UIColor orangeColor];
            }
        }
            break;
        case 1:
        {
            //水域等级
            [filterCell updateNameLabelWithText:_list2[indexPath.row]];
            if (indexPath.row == _oldSelectLevelIndex) {
                filterCell.backgroundColor = [UIColor orangeColor];
            }
        }
            
        case 2:
        {
            //变化前类型
            [filterCell updateNameLabelWithText:_list3[indexPath.row]];
            if (indexPath.row == _oldBeforeTypeIndex) {
                filterCell.backgroundColor = [UIColor orangeColor];
            }
        }
            break;
        case 3:
        {
            //变化后类型
            [filterCell updateNameLabelWithText:_list4[indexPath.row]];
            if (indexPath.row == _oldAfterTypeIndex) {
                filterCell.backgroundColor = [UIColor orangeColor];
            }
        }
            break;
        case 4:
        {
            //是否合理
            [filterCell updateNameLabelWithText:_list5[indexPath.row]];
            if (indexPath.row == _oldResonableIndex) {
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
        ChangeReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ChangeReusableView" forIndexPath:indexPath];
        switch (indexPath.section) {
            case 0:
            {
                headerView.TypeLabel.text = @"行政区划";
                headerView.valueButton.hidden = NO;
                [headerView.valueButton setTitle:_selectArea forState:UIControlStateNormal];
            }
                break;
            case 1:
            {
                headerView.TypeLabel.text = @"水域等级";
                headerView.valueButton.hidden = YES;

            }
                break;
            case 2:
            {
                headerView.TypeLabel.text = @"变化前类型";
                headerView.valueButton.hidden = NO;
                [headerView.valueButton setTitle:_selectBeforeType forState:UIControlStateNormal];
            }
                break;
            case 3:
            {
                headerView.TypeLabel.text = @"变化后类型";
                headerView.valueButton.hidden = NO;
                [headerView.valueButton setTitle:_selectBeforeType forState:UIControlStateNormal];
            }
                break;
            case 4:
            {
                headerView.TypeLabel.text = @"是否合理";
                headerView.valueButton.hidden = YES;
            }
                break;
            default:
                break;
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
static NSInteger _oldBeforeTypeIndex;//上一次选择 变化前类型
static NSInteger _oldAfterTypeIndex;//上一次选择 变化后类型
static NSInteger _oldResonableIndex;//上一次选择 是否合理
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了section %ld row %ld",indexPath.section,indexPath.row);
    switch (indexPath.section) {
        case 0:
        {
            //区域选择
            _selectArea = _list1[indexPath.row];
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
            //水域等级
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
        case 2:
        {
            //变化前类型
            NSIndexPath *oldIndex = [NSIndexPath indexPathForItem:_oldBeforeTypeIndex inSection:2];
            //上一次选择的cell
            FilterCollectionCell *oldCell = (FilterCollectionCell *)[collectionView cellForItemAtIndexPath:oldIndex];
            oldCell.backgroundColor = BG_COLOR;//设置成原来的颜色
            //等级选择
            FilterCollectionCell *filterCell = (FilterCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
            filterCell.backgroundColor = [UIColor orangeColor];
            _oldBeforeTypeIndex = indexPath.row;
            
        }
            break;
        case 3:
        {
            //变化后类型
            NSIndexPath *oldIndex = [NSIndexPath indexPathForItem:_oldAfterTypeIndex inSection:3];
            //上一次选择的cell
            FilterCollectionCell *oldCell = (FilterCollectionCell *)[collectionView cellForItemAtIndexPath:oldIndex];
            oldCell.backgroundColor = BG_COLOR;//设置成原来的颜色
            //等级选择
            FilterCollectionCell *filterCell = (FilterCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
            filterCell.backgroundColor = [UIColor orangeColor];
            _oldAfterTypeIndex = indexPath.row;
            
        }
            break;
        case 4:
        {
            //是否合理
            NSIndexPath *oldIndex = [NSIndexPath indexPathForItem:_oldResonableIndex inSection:4];
            //上一次选择的cell
            FilterCollectionCell *oldCell = (FilterCollectionCell *)[collectionView cellForItemAtIndexPath:oldIndex];
            oldCell.backgroundColor = BG_COLOR;//设置成原来的颜色
            //等级选择
            FilterCollectionCell *filterCell = (FilterCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
            filterCell.backgroundColor = [UIColor orangeColor];
            _oldResonableIndex = indexPath.row;
            
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
}

//点击背景取消键盘
- (IBAction)tapBackground:(id)sender
{
    [self.firstTextField resignFirstResponder];
    [self.secondTextField resignFirstResponder];
    [self.watersNameTextField resignFirstResponder];
}

@end
