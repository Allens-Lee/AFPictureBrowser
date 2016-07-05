//
//  AFPictureBrowserView.m
//  AFPictureBrowser
//
//  Created by 李鑫浩 on 16/7/2.
//  Copyright © 2016年 李鑫浩. All rights reserved.
//

#import "AFPictureBrowser.h"
#import "AFTempConverData.h"
#import "AFZoomView.h"

#define kWindow [[[UIApplication sharedApplication] delegate]window]

@interface AFPictureBrowser ()<UIScrollViewDelegate>
{
    UIView *m_pBackgroundView;
    UIScrollView *m_pScrollView;
    UILabel *m_pPage;
    NSArray *m_arrImageView;
    NSArray *m_arrImageUrl;
    CGFloat m_fItemWidth;
    NSInteger m_iCurrentPage;
    NSTimer *m_pTimer;
}

@end

@implementation AFPictureBrowser

- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        m_fItemWidth = self.frame.size.width + 20;
        
        m_pBackgroundView = [[UIView alloc]initWithFrame:self.bounds];
        m_pBackgroundView.backgroundColor = [UIColor blackColor];
        m_pBackgroundView.alpha = 0.0f;
        [self addSubview:m_pBackgroundView];
        
        m_pScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, m_fItemWidth, self.frame.size.height)];
        m_pScrollView.delegate = self;
        m_pScrollView.backgroundColor = [UIColor clearColor];
        m_pScrollView.pagingEnabled = YES;
        [m_pScrollView alwaysBounceHorizontal];
        [self addSubview:m_pScrollView];
        
        m_pPage = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 30, self.frame.size.width, 20)];
        m_pPage.textColor = [UIColor whiteColor];
        m_pPage.font = [UIFont systemFontOfSize:13];
        m_pPage.textAlignment = NSTextAlignmentCenter;
        [self addSubview:m_pPage];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    CGRect fScreenBounds = [[UIScreen mainScreen] bounds];
    CGRect fFrame = CGRectMake(0, 0, fScreenBounds.size.width, fScreenBounds.size.height);
    [kWindow addSubview:self];
    [super setFrame:fFrame];
}

#pragma mark -- public method
- (void)ShowWithImageViews:(NSArray*)views SelectedView:(UIImageView*)selectedView
{
    [self SetImageViewsFromArray:views];
    if (m_arrImageView.count > 0)
    {
        if ([selectedView isKindOfClass:[UIImageView class]] && [m_arrImageView containsObject:selectedView])
        {
            [self ShowSelectedImageView:selectedView];
        }
        else
        {
            [self ResetAllImageView:m_arrImageView[0]];
        }
    }
    else
    {
        [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(RemoveFromSuperView) userInfo:nil repeats:NO];
    }
}

- (void)ShowWithImageViews:(NSArray*)views SelectedView:(UIImageView*)selectedView AllImageUrls:(NSArray *)urls
{
    if (views.count == urls.count)
    {
        [self ShowWithImageViews:views SelectedView:selectedView];
        m_arrImageUrl = [urls copy];
    }
    else
    {
        [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(RemoveFromSuperView) userInfo:nil repeats:NO];
    }
}

- (void)ShowWithImageUrls:(NSArray *)urls
{
    if (urls.count > 0)
    {
        m_arrImageUrl = [urls copy];
        NSMutableArray *arrImageView = [NSMutableArray array];
        for (NSInteger i = 0; i < urls.count; i ++)
        {
            UIImageView *imageView = [[UIImageView alloc]init];
            [arrImageView addObject:imageView];
        }
        m_arrImageView = arrImageView;
        [self SetImageViewsFromArray:m_arrImageView];
        [self ResetAllImageView:m_arrImageView[0]];
        [self StartLoadNearImageView];
    }
    else
    {
        [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(RemoveFromSuperView) userInfo:nil repeats:NO];
    }
}

#pragma mark -- Target method
- (void)RemoveFromSuperView
{
    [m_pTimer invalidate];
    m_pTimer = nil;
    [self removeFromSuperview];
}

- (void)HidePageLable
{
    [UIView animateWithDuration:1.0f animations:^{
        m_pPage.alpha = 0.0f;
    }];
}

#pragma mark -- pravite method
- (void)SetImageViewsFromArray:(NSArray*)views
{
    NSMutableArray *imgViews = [NSMutableArray array];
    for(id obj in views)
    {
        if([obj isKindOfClass:[UIImageView class]])
        {
            [imgViews addObject:obj];
            UIImageView *imageView = obj;
            AFTempConverData *pData = [AFTempConverData TempConverDataForView:imageView];
            [pData SetTempConverDataFromView:imageView];
        }
    }
    m_arrImageView = [imgViews copy];
}

- (void)ShowSelectedImageView:(UIImageView *)imageView
{
    imageView.frame = [self convertRect:imageView.frame fromView:imageView.superview];
    [self addSubview:imageView];
    [UIView animateWithDuration:0.3f animations:^{
        imageView.frame = [self ResetImageViewFrame:imageView];
        m_pBackgroundView.alpha = 1.0f;
    }completion:^(BOOL finished){
        [self ResetAllImageView:imageView];
        [self StartLoadNearImageView];
    }];
}

- (void)ResetAllImageView:(UIImageView *)imageView
{
    m_iCurrentPage = [m_arrImageView indexOfObject:imageView];
    m_pBackgroundView.alpha = 1.0f;
    [m_pScrollView setContentSize:CGSizeMake(m_fItemWidth * m_arrImageView.count, 0)];
    [m_pScrollView setContentOffset:CGPointMake(m_fItemWidth * [m_arrImageView indexOfObject:imageView], 0)];
    for (NSInteger i = 0; i < m_arrImageView.count; i ++)
    {
        UIImageView *pImageView = m_arrImageView[i];
        AFZoomView *pZoomView = [[AFZoomView alloc]initWithFrame:CGRectMake(i * m_fItemWidth, 0, 0, 0)];
        [pZoomView ShowZoomViewWithImageView:pImageView];
        __weak typeof(self) weakSelf = self;
        pZoomView.CancleShow = ^(){
            [weakSelf PrepareRemoveSelf];
            [weakSelf RemoveSelfFromSuperview];
        };
        pZoomView.tag = 100 + i;
        [m_pScrollView addSubview:pZoomView];
    }
    [self ChangePageLableText];
}

- (CGRect)ResetImageViewFrame:(UIImageView *)imageView
{
    CGSize size = (imageView.image) ? imageView.image.size : imageView.frame.size;
    CGFloat fWidth = 0.0,fHeight = 0.0;
    if ((size.width >= self.frame.size.width || size.height >= self.frame.size.height) && (size.height / size.width <= 2.0f && size.width / size.height <= 2.0f))
    {
        if (size.height * (self.frame.size.width / size.width) > self.frame.size.height)
        {
            fHeight = self.frame.size.height;
            fWidth = size.width * fHeight / size.height;
        }
        else
        {
            fWidth = self.frame.size.width;
            fHeight = fWidth * size.height / size.width;
        }
    }
    else
    {
        fWidth = size.width;
        fHeight = size.height;
        if (size.height / size.width > 2.0f)
        {
            if (size.width > self.frame.size.width)
            {
                fWidth = self.frame.size.width;
                fHeight = fWidth * size.height / size.width;
            }
        }
        else if (size.width / size.height > 2.0f)
        {
            fWidth = self.frame.size.width;
            fHeight = fWidth * size.height / size.width;
        }
    }
    if (size.height / size.width > 2.0f)
    {
        CGFloat yMargin = fHeight > self.frame.size.height ? 0.0f : (self.frame.size.height - fHeight) / 2.0f;
        return CGRectMake((self.frame.size.width - fWidth) / 2.0f, yMargin, fWidth, fHeight);
    }
    else
    {
        return CGRectMake((self.frame.size.width - fWidth) / 2.0f, (self.frame.size.height - fHeight) / 2.0f, fWidth, fHeight);
    }
}

- (UIImageView *)GetCurrentView
{
    NSInteger iPage = roundf(m_pScrollView.contentOffset.x / m_pScrollView.frame.size.width);
    return (UIImageView *)m_arrImageView[iPage];
}

- (void)PrepareRemoveSelf
{
    for (NSInteger i = 0; i < m_arrImageView.count; i ++)
    {
        UIImageView *pImageView = m_arrImageView[i];
        if (pImageView != [self GetCurrentView])
        {
            AFTempConverData *pData = [AFTempConverData TempConverDataForView:pImageView];
            pImageView.transform = CGAffineTransformIdentity;
            pImageView.frame = pData.frame;
            pImageView.transform = pData.transform;
            pImageView.userInteractionEnabled = pData.userInteratctionEnabled;
            [pData.superview addSubview:pImageView];
        }
    }
}

- (void)RemoveSelfFromSuperview
{
    UIImageView *pCurrentImageView = [self GetCurrentView];
    pCurrentImageView.frame = [self convertRect:pCurrentImageView.frame fromView:pCurrentImageView.superview];
    [self addSubview:pCurrentImageView];
    //整理pCurrentImageView的Frame
    CGSize sSize = CGSizeMake(pCurrentImageView.frame.size.width, pCurrentImageView.frame.size.height);
    CGPoint pPoint = CGPointMake(pCurrentImageView.center.x, pCurrentImageView.center.y);
    pCurrentImageView.transform = CGAffineTransformIdentity;
    pCurrentImageView.frame = CGRectMake(0, 0, sSize.width, sSize.height);
    pCurrentImageView.center = pPoint;
    //缩放
    AFTempConverData *pTempConverData = [AFTempConverData TempConverDataForView:pCurrentImageView];
    [UIView animateWithDuration:0.3f animations:^{
        if (!CGRectIntersectsRect([self convertRect:pTempConverData.frame fromView:pTempConverData.superview], self.frame) || [NSStringFromCGRect(pTempConverData.frame) isEqualToString:NSStringFromCGRect(CGRectZero)])
        {
            pCurrentImageView.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
            pCurrentImageView.alpha = 0.0f;
        }
        else
        {
            pCurrentImageView.frame = [self convertRect:pTempConverData.frame fromView:pTempConverData.superview];
        }
        m_pBackgroundView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        pCurrentImageView.transform = CGAffineTransformIdentity;
        pCurrentImageView.frame = pTempConverData.frame;
        pCurrentImageView.userInteractionEnabled = pTempConverData.userInteratctionEnabled;
        pCurrentImageView.transform = pTempConverData.transform;
        pCurrentImageView.alpha = 1.0f;
        [pTempConverData.superview addSubview:pCurrentImageView];
        [self RemoveFromSuperView];
    }];
}

- (void)ChangePageLableText
{
    m_pPage.alpha = 1.0f;
    m_pPage.text = [NSString stringWithFormat:@"%li/%li",m_iCurrentPage + 1,m_arrImageView.count];
    [m_pTimer invalidate];
    m_pTimer = nil;
    m_pTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(HidePageLable) userInfo:nil repeats:NO];
}

#pragma mark -- UIScrollViewDelegate method
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger iCurrentPage = roundf(scrollView.contentOffset.x / scrollView.frame.size.width);
    if (iCurrentPage != m_iCurrentPage)
    {
        AFZoomView *pZoomView = (AFZoomView *)[scrollView viewWithTag:100 + m_iCurrentPage];
        [pZoomView RestoreViewScale];
        m_iCurrentPage = iCurrentPage;
        [self StartLoadNearImageView];
        [self ChangePageLableText];
    }
}

#pragma mark -- 加载前后视图的图片
- (void)StartLoadNearImageView
{
    if (m_arrImageUrl.count <= 0){
        return;
    }
    if (m_iCurrentPage == 0)
    {
        for (NSInteger i = 0; i < 2; i ++)
        {
            AFZoomView *pZoomView = [m_pScrollView viewWithTag:m_iCurrentPage + i + 100];
            [pZoomView StartLoadImageWithUrl:m_arrImageUrl[m_iCurrentPage + i ]];
        }
    }
    else if (m_iCurrentPage == m_arrImageView.count - 1)
    {
        for (NSInteger i = 0; i < 2; i ++)
        {
            AFZoomView *pZoomView = [m_pScrollView viewWithTag:m_iCurrentPage - i + 100];
            [pZoomView StartLoadImageWithUrl:m_arrImageUrl[m_iCurrentPage - i]];
        }
    }
    else
    {
        for (NSInteger i = 0; i < 3; i ++)
        {
            AFZoomView *pZoomView = [m_pScrollView viewWithTag:m_iCurrentPage + i + 99];
            [pZoomView StartLoadImageWithUrl:m_arrImageUrl[m_iCurrentPage + i - 1]];
        }
    }
}

@end
