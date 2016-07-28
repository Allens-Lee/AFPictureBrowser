//
//  AFConverView.h
//  AFPictureBrowser
//
//  Created by 李鑫浩 on 16/7/2.
//  Copyright © 2016年 李鑫浩. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  该类是作为记录所有imageview的初始数据存在的
 */
@interface AFTempConverData : NSObject

/**
 *  imageview的初始父视图
 */
@property (nonatomic, strong) UIView *superview;
/**
 *  imageview的初始frame
 */
@property (nonatomic, assign) CGRect frame;

/**
 *  imageview的初始仿射
 */
@property (nonatomic) CGAffineTransform transform;

/**
 *  初始化
 *
 *  @param view 记录对象
 *
 *  @return 记录完成后的数据
 */
+ (instancetype)TempConverDataForView:(UIView *)view;

/**
 *  对记录对象的记录操作
 *
 *  @param view 记录对象
 */
- (void)SetTempConverDataFromView:(UIView *)view;


/**
 *  获取调整后的imageview的大小
 *
 *  @param imageView 处理对象
 *
 *  @return size
 */
+ (CGSize)GetAfterAdjustSizeWithImageView:(UIImageView *)imageView;

@end
