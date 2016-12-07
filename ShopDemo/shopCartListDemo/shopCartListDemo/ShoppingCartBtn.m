//
//  ShoppingCartView.m
//  DuoBao
//
//  Created by ivan on 16/9/28.
//  Copyright © 2016年 豪帅. All rights reserved.
//

#import "ShoppingCartBtn.h"

@implementation ShoppingCartBtn{
    UILabel *_cntLabel;
    UIButton *_rightBtn;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}
-(void)setupView
{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 54, 44);
    [rightBtn setImage:[UIImage imageNamed:@"TabCartSelected"] forState:UIControlStateNormal];
    [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
//    [rightBtn addTarget:self action:@selector(goShoppingCarListVc) forControlEvents:UIControlEventTouchUpInside];
    _rightBtn = rightBtn;
    UILabel *cntLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 7, 15, 13)];
    cntLabel.textColor = Color(237, 20, 91);
    cntLabel.textAlignment = NSTextAlignmentCenter;
    cntLabel.font = [UIFont boldSystemFontOfSize:11];
    cntLabel.backgroundColor = [UIColor whiteColor];
    cntLabel.layer.cornerRadius = CGRectGetHeight(cntLabel.bounds)/2;
    cntLabel.layer.borderColor = Color(237, 20, 91).CGColor;
    cntLabel.layer.borderWidth = 0.5f;
    cntLabel.layer.masksToBounds = YES;
    _cntLabel = cntLabel;
    [rightBtn addSubview:cntLabel];

        cntLabel.hidden = YES;

    [self addSubview:rightBtn];
}
-(void)setCnt:(NSInteger)cnt
{
    if (cnt) {
        CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        shakeAnimation.duration = 0.25f;
        shakeAnimation.fromValue = [NSNumber numberWithFloat:-5];
        shakeAnimation.toValue = [NSNumber numberWithFloat:5];
        shakeAnimation.autoreverses = YES;
        [self.layer addAnimation:shakeAnimation forKey:nil];
        
        _cnt = cnt;
        _cntLabel.hidden = NO;
        CATransition *animation = [CATransition animation];
        animation.duration = 0.25f;
        if (cnt>99) {
            _cntLabel.frame = CGRectMake(35, 7, 22, 13);
            _cntLabel.font = [UIFont boldSystemFontOfSize:10];
            _cntLabel.text = @"99+";
        }else{
            _cntLabel.frame =  CGRectMake(35, 7, 15, 13);
            _cntLabel.font = [UIFont boldSystemFontOfSize:11];
            _cntLabel.text = [NSString stringWithFormat:@"%ld",cnt];
            [_cntLabel.layer addAnimation:animation forKey:nil];
        }
    }else{
        _cntLabel.hidden = YES;
    }
    
    
}
-(void)setBtnAction:(SEL)sel delegate:(id)delegate;
{
    if (delegate && [delegate respondsToSelector:sel]) {
        [_rightBtn addTarget:delegate action:sel forControlEvents:UIControlEventTouchUpInside];
    }
}
@end
