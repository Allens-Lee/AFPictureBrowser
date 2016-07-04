//
//  ViewController.m
//  AFPictureBrowser
//
//  Created by 李鑫浩 on 16/7/2.
//  Copyright © 2016年 李鑫浩. All rights reserved.
//

#import "ViewController.h"
#import "AFPictureBrowserView.h"
#import "TableViewCell.h"
#import "AFNormalViewController.h"
#import "AFScrollerViewController.h"
#import "AFTableViewController.h"
#import "AFUrlViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *m_pTableView;
    NSArray *m_arrCellTitle;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"AF图片浏览器";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    m_arrCellTitle = @[@"普通视图",@"ScrollView视图",@"表视图",@"纯URL"];
    
    m_pTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    m_pTableView.dataSource = self;
    m_pTableView.delegate = self;
    m_pTableView.rowHeight = 44;
    [self.view addSubview:m_pTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- UITableViewDataSource method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_arrCellTitle.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *pCell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
    if (pCell == nil) {
        pCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableViewCell"];
    }
    pCell.textLabel.text = m_arrCellTitle[indexPath.row];
    pCell.textLabel.font = [UIFont systemFontOfSize:15];
    return pCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch (indexPath.row)
    {
        case 0:
        {
            AFNormalViewController *pVC = [[AFNormalViewController alloc]init];
            [self.navigationController pushViewController:pVC animated:YES];
        }
            break;
        case 1:
        {
            AFScrollerViewController *pVC = [[AFScrollerViewController alloc]init];
            [self.navigationController pushViewController:pVC animated:YES];
        }
            break;
        case 2:
        {
            AFTableViewController *pVC = [[AFTableViewController alloc]init];
            [self.navigationController pushViewController:pVC animated:YES];
        }
            break;
        case 3:
        {
            AFUrlViewController *pVC = [[AFUrlViewController alloc]init];
            [self.navigationController pushViewController:pVC animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
