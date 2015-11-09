//
//  ThirdViewController.m
//  SuZhouProject
//  *************资料**************
//  Created by teddy on 15/9/30.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "ThirdViewController.h"
#import "CusHeadImageView.h"

@interface ThirdViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_List1;//数据源
    NSMutableArray *_List2;//数据源
    NSMutableArray *_List3;//数据源
    
    NSArray *_images1;//图片源
    NSArray *_images2;//图片源
    NSArray *_images3;//图片源
    
    NSString *_selectRow;//选择的行数传递的参数
}
@property (weak, nonatomic) IBOutlet UITableView *dataTable;

@end

@implementation ThirdViewController

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
#if __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        if ([self.dataTable respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.dataTable setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
    }
#endif
    if ([self.dataTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.dataTable setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"资料";
    
    self.dataTable.backgroundColor = BG_COLOR;
    self.dataTable.delegate  = self;
    self.dataTable.dataSource = self;
    
    _images1 = @[@"rivier",@"lakes",@"batang"];
    _images2 = @[@"add",@"decrease",@"kuahe",@"developer"];
    _images3 = @[@"developer"];
}

//获取网络数据
- (void)getWebData
{
    [SVProgressHUD showWithStatus:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [RequestHttps fetchWithType:@"Information" Results:@"" completion:^(NSArray *datas) {
            //成功
            if (datas.count == 0) {
                [SVProgressHUD dismissWithError:@"数据为空"];
                return;
            }
            if (_List1 == nil) {
                _List1 = [NSMutableArray array];
            }else{
                [_List1 removeAllObjects];
            }
            if (_List2 == nil) {
                _List2 = [NSMutableArray array];
            }else{
                [_List2 removeAllObjects];
            }
            if (_List3 == nil) {
                _List3 = [NSMutableArray array];;
            }else{
                [_List3 removeAllObjects];
            }
            [SVProgressHUD dismissWithSuccess:nil];
            for (NSDictionary *dict in datas) {
                NSString *type = [dict objectForKey:@"type1"];
                if ([type isEqualToString:@"基础信息"]) {
                    //基础信息数据源
                    [_List1 addObject:dict];
                }
                else if ([type isEqualToString:@"变化信息"])
                {
                    //变化信息数据源
                    [_List2 addObject:dict];
                }else{
                    //开发利用要素数据源
                    [_List3 addObject:dict];
                }
            }
            [self.dataTable reloadData];
        } error:^(NSError *error) {
        //失败
            [SVProgressHUD dismissWithError:@"加载数据失败"];
        }];
    });
}

//切换界面的时候
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
      [self getWebData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return _List1.count;
            break;
        case 1:
            return _List2.count;
            break;
        case 2:
            return _List3.count;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"myCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    switch (indexPath.section) {
        case 0:
        {
            NSDictionary *dict = _List1[indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@:数量%@条 面积%@㎡", [dict objectForKey:@"type2"], [dict objectForKey:@"num"], [dict objectForKey:@"area"]];
            cell.imageView.image = [UIImage imageNamed:_images1[indexPath.row]];
        }
            break;
        case 1:
        {
            NSDictionary *dict = _List2[indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@:数量%@条 面积%@㎡", [dict objectForKey:@"type2"], [dict objectForKey:@"num"], [dict objectForKey:@"area"]];
            cell.imageView.image = [UIImage imageNamed:_images2[indexPath.row]];
        }
            break;
        case 2:
        {
            NSDictionary *dict = _List3[indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@:数量%@条 面积%@㎡", [dict objectForKey:@"type2"], [dict objectForKey:@"num"], [dict objectForKey:@"area"]];
            cell.imageView.image = [UIImage imageNamed:_images3[indexPath.row]];
        }
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
#if __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
    }
#endif
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CusHeadImageView *headImage = (CusHeadImageView *)[[[NSBundle mainBundle] loadNibNamed:@"cusHeaderView" owner:nil options:nil] lastObject];
    switch (section) {
        case 0:
        {
            headImage.headTitleLabel.text = @"   基础信息";
        }
            break;
        case 1:
        {
            headImage.headTitleLabel.text = @"   变化信息";
        }
            break;
        case 2:
        {
            headImage.headTitleLabel.text = @"   利用开发要素";
        }
            break;
        default:
            return nil;
            break;
    }
    return headImage;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                _selectRow = @"GetRiverlist";//获取河道列表的服务
            }
            else if (indexPath.row == 1)
            {
                _selectRow = @"GetLakelist";//获取湖泊列表的服务
            }else{
                _selectRow = @"GetPondlist";//获取塘坝列表的服务
            }
            //基础信息
            [self performSegueWithIdentifier:@"basicInfo" sender:nil];
        }
            break;
        case 1:
        {
            NSDictionary *dict = _List2[indexPath.row];
            _selectRow = [dict objectForKey:@"type2"];
            //变化信息
             [self performSegueWithIdentifier:@"changedInfo" sender:nil];
        }
            break;
        case 2:
        {
            //利用开发要素
            [self performSegueWithIdentifier:@"DeveloperChanged" sender:nil];
        }
            break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"basicInfo"]) {
        id theSegue = segue.destinationViewController;
        [theSegue setValue:_selectRow forKey:@"basicType"];
    }
    else if ([segue.identifier isEqualToString:@"changedInfo"])
    {
        id theSegue = segue.destinationViewController;
        [theSegue setValue:_selectRow forKey:@"changeType"];
    }
    else
    {
        id theSegue = segue.destinationViewController;
         [theSegue setValue:@"开发利用要素" forKey:@"developeType"];
    }
}

@end
