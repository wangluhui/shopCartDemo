//
//  shopCartCell.m
//  shopCartListDemo
//
//  Created by wanglh on 15/6/1.
//  Copyright (c) 2015年 wanglh. All rights reserved.
//

#import "shopCartCell.h"
@implementation shopCartCell
- (void)awakeFromNib {
    _headImageView.layer.cornerRadius = CGRectGetHeight(_headImageView.bounds)/2;
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
    
    self.shopCartBlock(self.headImageView);
}
@end
