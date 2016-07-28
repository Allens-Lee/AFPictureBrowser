//
//  AFPictureBrowserView.h
//  AFPictureBrowser
//
//  Created by 李鑫浩 on 16/7/2.
//  Copyright © 2016年 李鑫浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AFPictureBrowser : UIView

/**
 *  已知所有要展示的imageview，选择其中一个imageview作为优先查看对象
 *
 *  @param views        所有的imageview组成的一个数组
 *  @param selectedView 被选中的其中一个的imageview
 */
- (void)ShowWithImageViews:(NSArray*)views SelectedView:(UIImageView*)selectedView;

/**
 *  该方法主要用于已知缩略图加载详细图的情况
 *
 *  @param views        所有的imageview组成的一个数组
 *  @param selectedView 被选中的其中一个的imageview
 *  @param urls          所有的imageview的image的详细图的URL
 */
- (void)ShowWithImageViews:(NSArray*)views SelectedView:(UIImageView*)selectedView AllImageUrls:(NSArray *)urls;

/**
 *  只有所有要展示的imageview的image的URL，通过URL来浏览图片
 *
 *  @param urls 所有imageview的image的URL
 *  @param item 选中优先展示的imageview（Item从0开始，并且只能小于urls的个数）
 */
- (void)ShowWithImageUrls:(NSArray *)urls SelectItem:(NSInteger)item;

@end
