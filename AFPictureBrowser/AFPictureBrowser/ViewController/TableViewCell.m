//
//  TableViewCell.m
//  AFPictureBrowser
//
//  Created by 李鑫浩 on 16/7/3.
//  Copyright © 2016年 李鑫浩. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        m_pImageV = [[UIImageView alloc]init];
        [self.contentView addSubview:m_pImageV];
    }
    return self;
}

- (void)SetImageViewWithImage:(UIImage *)image
{
    m_pImageV.image = image;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    m_pImageV.frame = CGRectMake((self.frame.size.width - 100) / 2.0, 0, 100, 150);
}

@end
