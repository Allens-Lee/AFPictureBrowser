//
//  AFNormalViewController.m
//  AFPictureBrowser
//
//  Created by 李鑫浩 on 16/7/3.
//  Copyright © 2016年 李鑫浩. All rights reserved.
//

#import "AFNormalViewController.h"
#import "AFPictureBrowser.h"

@interface AFNormalViewController ()
{
    NSMutableArray *m_arrImageView;
}

@end

@implementation AFNormalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    m_arrImageView = [NSMutableArray array];
    
    
    CGFloat margin = (self.view.frame.size.width - 200) / 3.0f;
    for (NSInteger i = 0; i < 4; i ++)
    {
        UIImageView *pImageV = [[UIImageView alloc]initWithFrame:CGRectMake( margin + (margin + 100) * (i / 2), (i % 2) * (150 + 20) + 150, 100, 150)];
        pImageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%li", i + 1]];
        pImageV.userInteractionEnabled = YES;
        [self.view addSubview:pImageV];
        
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
