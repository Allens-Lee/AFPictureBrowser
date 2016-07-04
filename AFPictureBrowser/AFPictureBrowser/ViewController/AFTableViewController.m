//
//  AFTableViewController.m
//  AFPictureBrowser
//
//  Created by 李鑫浩 on 16/7/3.
//  Copyright © 2016年 李鑫浩. All rights reserved.
//

#import "AFTableViewController.h"
#import "AFPictureBrowserView.h"
#import "TableViewCell.h"

@interface AFTableViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *m_pTableView;
    NSArray *m_arrCellTitle;
}

@end

@implementation AFTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    m_pTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    m_pTableView.dataSource = self;
    m_pTableView.delegate = self;
    m_pTableView.rowHeight = 150;
    [self.view addSubview:m_pTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- UITableViewDataSource method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 16;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *pCell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
    if (pCell == nil) {
        pCell = [[TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableViewCell"];
    }
    [pCell SetImageViewWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%li",indexPath.row % 4 + 1]]];
    return pCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSArray *arrIndex = [tableView indexPathsForVisibleRows];
    NSMutableArray *arrImageView = [NSMutableArray array];
    for (NSIndexPath *indexPath in arrIndex) {
        TableViewCell *pCell = [tableView cellForRowAtIndexPath:indexPath];
        [arrImageView addObject:(UIImageView *)pCell->m_pImageV];
    }
    TableViewCell *pCell = [tableView cellForRowAtIndexPath:indexPath];
    AFPictureBrowserView *pPictureBrowserV = [[AFPictureBrowserView alloc]initWithFrame:CGRectZero];
    [pPictureBrowserV ShowWithImageViews:arrImageView SelectedView:(UIImageView *)pCell->m_pImageV];
}


@end
