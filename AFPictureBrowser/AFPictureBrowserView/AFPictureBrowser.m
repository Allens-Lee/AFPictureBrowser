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
#define kScreenBounds [[UIScreen mainScreen] bounds]
#define kItemWidth (kScreenBounds.size.width + 20)

@interface AFPictureBrowser ()<UIScrollViewDelegate>
{
    UIView *m_pBackgroundView;
    UIScrollView *m_pScrollView;
    UILabel *m_pPage;
    NSArray *m_arrImageView;
    NSArray *m_arrImageUrl;
    NSInteger m_iCurrentPage;
    NSTimer *m_pTimer;
}

@end

@implementation AFPictureBrowser

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, kScreenBounds.size.width, kScreenBounds.size.height);
        self.backgroundColor = [UIColor clearColor];
        
        m_pBackgroundView = [[UIView alloc]initWithFrame:self.bounds];
        m_pBackgroundView.backgroundColor = [UIColor blackColor];
        m_pBackgroundView.alpha = 0.0f;
        [self addSubview:m_pBackgroundView];
        
        m_pScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kItemWidth, self.frame.size.height)];
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

#pragma mark -- public method
- (void)ShowWithImageViews:(NSArray*)views SelectedView:(UIImageView*)selectedView
{
    NSArray *arrNewViews = [self CopyImageViewsFromArray:views];
    if ([views containsObject:selectedView]){
        selectedView = arrNewViews[[views indexOfObject:selectedView]];
    }
    views = arrNewViews;
    m_arrImageView = [self SetImageViewsFromArray:arrNewViews];
    if (m_arrImageView.count > 0)
    {
        [self ShowInWindow];
        if ([selectedView isKindOfClass:[UIImageView class]] && [m_arrImageView containsObject:selectedView])
        {
            [self ShowSelectedImageView:selectedView];
        }
        else
        {
            [self ResetAllImageView:m_arrImageView[0]];
        }
    }
}

- (void)ShowWithImageViews:(NSArray*)views SelectedView:(UIImageView*)selectedView AllImageUrls:(NSArray *)urls
{
    if ([self SetImageViewsFromArray:views].count == urls.count)
    {
        m_arrImageUrl = [urls copy];
        [self ShowWithImageViews:views SelectedView:selectedView];
    }
}

- (void)ShowWithImageUrls:(NSArray *)urls SelectItem:(NSInteger)item
{
    if (urls.count > 0)
    {
        [self ShowInWindow];
        m_arrImageUrl = [urls copy];
        NSMutableArray *arrImageView = [NSMutableArray array];
        for (NSInteger i = 0; i < urls.count; i ++)
        {
            UIImageView *imageView = [[UIImageView alloc]init];
            [arrImageView addObject:imageView];
        }
        m_arrImageView = arrImageView;
        [self SetImageViewsFromArray:m_arrImageView];
        item = item < urls.count ? item : 0;
        [self ResetAllImageView:m_arrImageView[item]];
        [self StartLoadNearImageView];
    }
}

#pragma mark -- Target method
- (void)RemoveFromSuperView
{
    [self DeallocTimer];
    kWindow.windowLevel = UIWindowLevelNormal;
    [self removeFromSuperview];
}

- (void)HidePageLable
{
    [UIView animateWithDuration:1.0f animations:^{
        m_pPage.alpha = 0.0f;
    }];
}

#pragma mark -- pravite method
- (NSArray *)CopyImageViewsFromArray:(NSArray *)views
{
    NSMutableArray *arrNewViews = [NSMutableArray array];
    for (id obj in views)
    {
        if ([obj isKindOfClass:[UIImageView class]])
        {
            UIImageView *pImageView = (UIImageView *)obj;
            UIImageView *pNewView = [[UIImageView alloc]init];
            pNewView.frame = pImageView.frame;
            [pImageView.superview addSubview:pNewView];
            pNewView.transform = pImageView.transform;
            pNewView.image =  pImageView.image;
            [arrNewViews addObject:pNewView];
        }
        else
        {
            [arrNewViews addObject:obj];
        }
    }
    return arrNewViews;
}

- (NSArray *)SetImageViewsFromArray:(NSArray*)views
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
    return imgViews;
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
    [m_pScrollView setContentSize:CGSizeMake(kItemWidth * m_arrImageView.count, 0)];
    [m_pScrollView setContentOffset:CGPointMake(kItemWidth * [m_arrImageView indexOfObject:imageView], 0)];
    for (NSInteger i = 0; i < m_arrImageView.count; i ++)
    {
        UIImageView *pImageView = m_arrImageView[i];
        AFZoomView *pZoomView = [[AFZoomView alloc]initWithFrame:CGRectMake(i * kItemWidth, 0, 0, 0)];
        [pZoomView ShowZoomViewWithImageView:pImageView];
        __weak typeof(self) weakSelf = self;
        pZoomView.CancleShow = ^(){
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
    CGSize sAdjustSize = [AFTempConverData GetAfterAdjustSizeWithImageView:imageView];
    CGFloat fWidth = sAdjustSize.width,fHeight = sAdjustSize.height;
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
        pCurrentImageView.transform = pTempConverData.transform;
        [self RemoveFromSuperView];
    }];
}

- (void)ShowInWindow
{
    kWindow.windowLevel = UIWindowLevelAlert;
    [kWindow addSubview:self];
}

- (UIImageView *)GetCurrentView
{
    NSInteger iPage = roundf(m_pScrollView.contentOffset.x / m_pScrollView.frame.size.width);
    return (UIImageView *)m_arrImageView[iPage];
}

- (void)DeallocTimer
{
    [m_pTimer invalidate];
    m_pTimer = nil;
}

- (void)ChangePageLableText
{
    m_pPage.alpha = 1.0f;
    m_pPage.text = [NSString stringWithFormat:@"%li/%li",m_iCurrentPage + 1,m_arrImageView.count];
    [self DeallocTimer];
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
            if (pZoomView != nil)
            {
                [pZoomView StartLoadImageWithUrl:m_arrImageUrl[m_iCurrentPage + i ]];
            }
        }
    }
    else if (m_iCurrentPage == m_arrImageView.count - 1)
    {
        for (NSInteger i = 0; i < 2; i ++)
        {
            AFZoomView *pZoomView = [m_pScrollView viewWithTag:m_iCurrentPage - i + 100];
            if (pZoomView != nil)
            {
                [pZoomView StartLoadImageWithUrl:m_arrImageUrl[m_iCurrentPage - i]];
            }
        }
    }
    else
    {
        for (NSInteger i = 0; i < 3; i ++)
        {
            AFZoomView *pZoomView = [m_pScrollView viewWithTag:m_iCurrentPage + i + 99];
            if (pZoomView != nil)
            {
                [pZoomView StartLoadImageWithUrl:m_arrImageUrl[m_iCurrentPage + i - 1]];
            }
        }
    }
}

@end
