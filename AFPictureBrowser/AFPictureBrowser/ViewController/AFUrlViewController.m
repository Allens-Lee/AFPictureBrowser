//
//  AFUrlViewController.m
//  AFPictureBrowser
//
//  Created by 李鑫浩 on 16/7/3.
//  Copyright © 2016年 李鑫浩. All rights reserved.
//

#import "AFUrlViewController.h"
#import "AFPictureBrowser.h"

@interface AFUrlViewController ()

@end

@implementation AFUrlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *pShow = [UIButton buttonWithType:UIButtonTypeCustom];
    pShow.frame = CGRectMake((self.view.frame.size.width - 200) / 2.0f, 100, 200, 50);
    [pShow setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [pShow setTitle:@"纯URL浏览图片" forState:UIControlStateNormal];
    pShow.titleLabel.font = [UIFont systemFontOfSize:15];
    [pShow addTarget:self action:@selector(ShowPictureBrowserView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pShow];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)ShowPictureBrowserView
{
    AFPictureBrowser *pPictureBrowserV = [[AFPictureBrowser alloc]initWithFrame:CGRectZero];
    [pPictureBrowserV ShowWithImageUrls:@[@"http://f.hiphotos.baidu.com/image/pic/item/a71ea8d3fd1f41348a8ca392211f95cad0c85ea6.jpg",@"http://e.hiphotos.baidu.com/image/pic/item/14ce36d3d539b600be63e95eed50352ac75cb7ae.jpg",@"http://f.hiphotos.baidu.com/image/pic/item/91529822720e0cf3a2cdbc240e46f21fbe09aa33.jpg",@"http://e.hiphotos.baidu.com/image/pic/item/2f738bd4b31c87019d17540f237f9e2f0608ffb2.jpg",@"http://d.hiphotos.baidu.com/image/pic/item/5d6034a85edf8db118248ebb0d23dd54574e74e3.jpg",@"http://h.hiphotos.baidu.com/image/pic/item/3801213fb80e7bec43f0523e2b2eb9389a506bc2.jpg",@"http://g.hiphotos.baidu.com/image/pic/item/6c224f4a20a446230761b9b79c22720e0df3d7bf.jpg",@"http://f.hiphotos.baidu.com/image/pic/item/7aec54e736d12f2eec17b2b54bc2d562843568d0.jpg",@"http://b.hiphotos.baidu.com/image/pic/item/9825bc315c6034a857770337ce134954082376ea.jpg",@"http://a.hiphotos.baidu.com/image/pic/item/838ba61ea8d3fd1f619c198c354e251f94ca5fea.jpg",@"http://e.hiphotos.baidu.com/image/pic/item/eac4b74543a98226a32990918f82b9014b90eb98.jpg",@"http://d.hiphotos.baidu.com/image/pic/item/7af40ad162d9f2d3c4f99f59acec8a136227cc98.jpg",@"http://c.hiphotos.baidu.com/image/pic/item/30adcbef76094b364e7aa05ba6cc7cd98c109d98.jpg",@"http://g.hiphotos.baidu.com/image/pic/item/bd315c6034a85edf9ba34e244b540923dd54758d.jpg"] SelectItem:3];
}

@end
