//
//  DeveloperChangedController.m
//  SuZhouProject
//  ***********开发利用要素**********
//  Created by teddy on 15/10/29.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "DeveloperChangedController.h"
#import "BasicInfoCell.h"

@interface DeveloperChangedController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_infoDataList;//数据源s
}

//开发要素列表
@property (weak, nonatomic) IBOutlet UITableView *developerTableView;
@end

@implementation DeveloperChangedController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *filterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    filterBtn.frame = (CGRect){0,0,30,30};
    [filterBtn setBackgroundImage:[UIImage imageNamed:@"filter"] forState:UIControlStateNormal];
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
    [self performSegueWithIdentifier:@"filterDeveloperChanged" sender:nil];
}

#pragma amark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // return _infoDataList.count;
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BasicInfoCell *InfoCell = (BasicInfoCell *)[[[NSBundle mainBundle] loadNibNamed:@"BasicInfoCell" owner:nil options:nil] lastObject];
    InfoCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    InfoCell.nameLabel.text = @"环城河段1";
    InfoCell.lengthImage.image = [UIImage imageNamed:@"length"];
    InfoCell.lengthLabel.text = @"面积:2345 km";
    InfoCell.areaImage.image = [UIImage imageNamed:@"change"];
    InfoCell.areaLabel.text = @"林地->池塘";
    return InfoCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,kScreenWidth,1}];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"developerInfoDetail" sender:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"filterDeveloperChanged"]) {
        id theSegue = segue.destinationViewController;
        //filterType
        //筛选类型
        [theSegue setValue:@"开发利用要素" forKey:@"filterType"];
    }
    else if ([segue.identifier isEqualToString:@"developerInfoDetail"])
    {
        //信息详情类型
        //typeInfo
        id theSegue = segue.destinationViewController;
        [theSegue setValue:@"开发利用要素" forKey:@"typeInfo"];
    }
}

@end
