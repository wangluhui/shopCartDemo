//
//  shopCartCell.m
//  shopCartListDemo
//
//  Created by wanglh on 15/6/1.
//  Copyright (c) 2015年 wanglh. All rights reserved.
//
/**
 
 *******************************************************
 *
 * 感谢您的支持， 如果下载的代码在使用过程中出现BUG或者其他问题
 * 您可以发邮件到183049213@qq.com
 * github下载地址 https://github.com/wangluhui/shopCartDemo
 *
 *******************************************************
 
 */

#import "shopCartCell.h"
@implementation shopCartCell
- (void)awakeFromNib {
    [super awakeFromNib];
    _headImageView.layer.cornerRadius = 35.0f;
    _headImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)refreshCellWithModel:(shopModel *)model
{
    _headImageView.image = [UIImage imageNamed:model.shoppingIcon];
    _deatailLabel.text = model.shoppingName;
}
- (IBAction)onClickCartBtn:(UIButton *)sender {
    
    if (self.shopCartBlock) {
        self.shopCartBlock(self.headImageView);
    }
}
@end
