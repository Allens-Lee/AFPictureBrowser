//
//  AFScrollerViewController.m
//  AFPictureBrowser
//
//  Created by 李鑫浩 on 16/7/3.
//  Copyright © 2016年 李鑫浩. All rights reserved.
//

#import "AFScrollerViewController.h"
#import "AFPictureBrowser.h"

@interface AFScrollerViewController ()
{
    NSMutableArray *m_arrImageView;
    UIScrollView *m_pScrollView;
}

@end

@implementation AFScrollerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    m_pScrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    m_pScrollView.backgroundColor = [UIColor clearColor];
    [m_pScrollView setContentSize:CGSizeMake(0, 150 * 21)];
    [self.view addSubview:m_pScrollView];
    
    m_arrImageView = [NSMutableArray array];
    for (NSInteger i = 0; i < 21; i ++)
    {
        UIImageView *pImageV = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 100) / 2.0f, i * 150 + 20, 100, 150)];
        pImageV.backgroundColor = [UIColor whiteColor];
        pImageV.contentMode = UIViewContentModeScaleAspectFill;
        pImageV.clipsToBounds = YES;
        pImageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%li", i % 7 + 1]];
        pImageV.userInteractionEnabled = YES;
        [m_pScrollView addSubview:pImageV];
        
        UITapGestureRecognizer *Tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ShowThisImage:)];
        [pImageV addGestureRecognizer:Tap];
        
        [m_arrImageView addObject:pImageV];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- Target method
- (void)ShowThisImage:(UIGestureRecognizer *)gesture
{
    AFPictureBrowser *pPictureBrowserV = [[AFPictureBrowser alloc]init];
    [pPictureBrowserV ShowWithImageViews:m_arrImageView SelectedView:(UIImageView *)gesture.view];
}


@end
