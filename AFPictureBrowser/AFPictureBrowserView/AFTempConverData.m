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
    if(dict==nil){
        dict = [NSMutableDictionary dictionary];
    }
    
    AFTempConverData *pTempConverData = dict[@(view.hash)];   //view.hash view的内存块编号
    if(pTempConverData==nil){
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
}

+ (CGSize)GetAfterAdjustSizeWithImageView:(UIImageView *)imageView
{
    CGSize size = (imageView.image) ? imageView.image.size : imageView.frame.size;
    CGFloat fFrameHeight = [[UIScreen mainScreen] bounds].size.height;
    CGFloat fFrameWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat fWidth = 0.0,fHeight = 0.0;
    if ((size.width >= fFrameWidth || size.height >= fFrameHeight) && size.height / size.width <= 2.0f)
    {
        if (size.height * fFrameWidth / size.width > fFrameHeight)
        {
            fHeight = fFrameHeight;
            fWidth = size.width * fHeight / size.height;
        }
        else
        {
            fWidth = fFrameWidth;
            fHeight = fWidth * size.height / size.width;
        }
    }
    else
    {
        fWidth = size.width;
        fHeight = size.height;
        if (size.height / size.width > 2.0f)
        {
            if (size.width > fFrameWidth)
            {
                fWidth = fFrameWidth;
                fHeight = fWidth * size.height / size.width;
            }
        }
    }
    return CGSizeMake(fWidth, fHeight);
}

@end
