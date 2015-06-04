//
//  shopCartCell.h
//  shopCartListDemo
//
//  Created by wanglh on 15/6/1.
//  Copyright (c) 2015年 wanglh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "shopModel.h"
@interface shopCartCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *deatailLabel;

- (IBAction)onClickCartBtn:(UIButton *)sender;
@property (nonatomic,copy)  void(^shopCartBlock)(UIImageView *imageView);
-(void)refreshCellWithModel:(shopModel *)model;
@end
