//
//  ImageScrollView.h
//  my -- 图片缩放2
//
//  Created by 李鑫浩 on 15/6/22.
//  Copyright (c) 2015年 app17. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AFZoomView : UIScrollView

/**
 *  单击取消图片浏览器的操作
 */
@property(nonatomic,copy)void (^CancleShow)();

/**
 *  初始化图片浏览器item
 *
 *  @param imageView item
 */
- (void)ShowZoomViewWithImageView:(UIImageView *)imageView;

/**
 *  恢复item的初始缩放比例
 */
- (void)RestoreViewScale;

/**
 *  开始加载视图操作
 *
 *  @param url 加载image的URL
 */
- (void)StartLoadImageWithUrl:(NSString *)url;

@end
