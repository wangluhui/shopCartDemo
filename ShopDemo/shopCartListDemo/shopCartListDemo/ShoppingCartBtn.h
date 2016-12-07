//
//  ShoppingCartView.h
//  DuoBao
//
//  Created by ivan on 16/9/28.
//  Copyright © 2016年 豪帅. All rights reserved.
//
#define Color(r,g,b)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define NavColor ([UIColor colorWithRed:237/255.0 green:20/255.0f blue:91/255.0f alpha:1.0f])

#import <UIKit/UIKit.h>

@interface ShoppingCartBtn : UIButton
@property (nonatomic,assign) NSInteger cnt;
-(void)setBtnAction:(SEL)sel delegate:(id)delegate;
@end
