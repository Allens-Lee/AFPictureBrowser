# AFPictureBrowser
简单好用的图片浏览器

主要用于图片的查看，可双击、捏合放大缩小图片，滑动还原图片，长按保存图片的基本功能，在点击查看某个imageview时还可以显示过程动画，同时对于关闭图片浏览器时也做了一定的动画处理。其中实现方法有以下三种，不可混搭使用，具体效果请查看demo。


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
 */
- (void)ShowWithImageUrls:(NSArray *)urls;

