//
//  TableViewCell.h
//  AFPictureBrowser
//
//  Created by 李鑫浩 on 16/7/3.
//  Copyright © 2016年 李鑫浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
{
    @public
    UIImageView *m_pImageV;
}

- (void)SetImageViewWithImage:(UIImage *)image;

@end
