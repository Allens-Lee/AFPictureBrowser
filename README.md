# AFPictureBrowser
简单好用的图片浏览器
/**
 *  已知所有要展示的imageview，选择其中一个imageview作为优先查看对象
 *
 *  @param views        所有的imageview组成的一个数组
 *  @param selectedView 被选中的其中一个的imageview
 */
- (void)ShowWithImageViews:(NSArray*)views SelectedView:(UIImageView*)selectedView;

/**
 *  该方法主要用于缩略图加载的方法
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
