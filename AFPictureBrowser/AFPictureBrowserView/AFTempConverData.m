//
//  AFConverView.m
//  AFPictureBrowser
//
//  Created by 李鑫浩 on 16/7/2.
//  Copyright © 2016年 李鑫浩. All rights reserved.
//

#import "AFTempConverData.h"

@implementation AFTempConverData

+ (instancetype)TempConverDataForView:(UIView *)view
{
    static NSMutableDictionary *dict = nil;
    if(dict==nil)
    {
        dict = [NSMutableDictionary dictionary];
    }
    
    AFTempConverData *pTempConverData = dict[@(view.hash)];   //view.hash view的内存块编号
    if(pTempConverData==nil)
    {
        pTempConverData = [[self alloc] init];
        dict[@(view.hash)] = pTempConverData;
    }
    return pTempConverData;
}

- (void)SetTempConverDataFromView:(UIView *)view
{
    CGAffineTransform trans = view.transform;
    view.transform = CGAffineTransformIdentity;
    self.superview = view.superview;
    self.frame     = view.frame;
    self.transform = trans;
    self.userInteratctionEnabled = view.userInteractionEnabled;
    view.transform = trans;
    view.userInteractionEnabled = NO;
}

@end
