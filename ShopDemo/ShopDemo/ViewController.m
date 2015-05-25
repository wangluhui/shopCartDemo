//
//  ViewController.m
//  ShopDemo
//
//  Created by wanglh on 15/5/16.
//  Copyright (c) 2015年 wanglh. All rights reserved.
//

#import "ViewController.h"
#define SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT   ([UIScreen mainScreen].bounds.size.height)

@interface ViewController ()
@property (nonatomic,strong) UIBezierPath *path;
@end

@implementation ViewController{
    CALayer     *layer;
    UILabel     *_cntLabel;
    NSInteger    _cnt;
    UIImageView *_imageView;
    UIButton    *_btn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     _cnt = 0;
    [self setUI];
    
}
-(void)setUI
{
    UIColor *customColor  = [UIColor colorWithRed:237/255.0 green:20/255.0 blue:91/255.0 alpha:1.0f];
    //
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn.frame = CGRectMake(50, SCREEN_HEIGHT * 0.7, 100, 30);
    [_btn setTitle:@"立即抢购" forState:UIControlStateNormal];
    [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [_btn setBackgroundImage:[UIImage imageNamed:@"ButtonRedLarge"] forState:UIControlStateNormal];
    [_btn addTarget:self action:@selector(startAnimation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn];
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    _imageView.image = [UIImage imageNamed:@"TabCartSelected@2x.png"];
    _imageView.center = CGPointMake(270, 320);
    [self.view addSubview:_imageView];
    // label
    _cntLabel = [[UILabel alloc] initWithFrame:CGRectMake(280, 295, 20, 20)];
    _cntLabel.textColor = customColor;
    _cntLabel.textAlignment = NSTextAlignmentCenter;
    _cntLabel.font = [UIFont boldSystemFontOfSize:13];
    _cntLabel.backgroundColor = [UIColor whiteColor];
    _cntLabel.layer.cornerRadius = CGRectGetHeight(_cntLabel.bounds)/2;
    _cntLabel.layer.masksToBounds = YES;
    _cntLabel.layer.borderWidth = 1.0f;
    _cntLabel.layer.borderColor = customColor.CGColor;
    [self.view addSubview:_cntLabel];
    if (_cnt == 0) {
        _cntLabel.hidden = YES;
    }
    
    self.path = [UIBezierPath bezierPath];
    [_path moveToPoint:CGPointMake(50, 150)];
    [_path addQuadCurveToPoint:CGPointMake(270, 300) controlPoint:CGPointMake(150, 20)];
}
-(void)startAnimation
{
    if (!layer) {
        _btn.enabled = NO;
        layer = [CALayer layer];
        layer.contents = (__bridge id)[UIImage imageNamed:@"test01.jpg"].CGImage;
        layer.contentsGravity = kCAGravityResizeAspectFill;
        layer.bounds = CGRectMake(0, 0, 50, 50);
        [layer setCornerRadius:CGRectGetHeight([layer bounds]) / 2];
        layer.masksToBounds = YES;
        layer.position =CGPointMake(50, 150);
        [self.view.layer addSublayer:layer];
    }
    [self groupAnimation];
}
-(void)groupAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = _path.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    CABasicAnimation *expandAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    expandAnimation.duration = 0.5f;
    expandAnimation.fromValue = [NSNumber numberWithFloat:1];
    expandAnimation.toValue = [NSNumber numberWithFloat:2.0f];
    expandAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CABasicAnimation *narrowAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    narrowAnimation.beginTime = 0.5;
    narrowAnimation.fromValue = [NSNumber numberWithFloat:2.0f];
    narrowAnimation.duration = 1.5f;
    narrowAnimation.toValue = [NSNumber numberWithFloat:0.5f];
    
    narrowAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[animation,expandAnimation,narrowAnimation];
    groups.duration = 2.0f;
    groups.removedOnCompletion=NO;
    groups.fillMode=kCAFillModeForwards;
    groups.delegate = self;
    [layer addAnimation:groups forKey:@"group"];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
//    [anim def];
    if (anim == [layer animationForKey:@"group"]) {
        _btn.enabled = YES;
        [layer removeFromSuperlayer];
        layer = nil;
        _cnt++;
        if (_cnt) {
            _cntLabel.hidden = NO;
        }
        CATransition *animation = [CATransition animation];
        animation.duration = 0.25f;
        _cntLabel.text = [NSString stringWithFormat:@"%d",_cnt];
        [_cntLabel.layer addAnimation:animation forKey:nil];
        
        CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        shakeAnimation.duration = 0.25f;
        shakeAnimation.fromValue = [NSNumber numberWithFloat:-5];
        shakeAnimation.toValue = [NSNumber numberWithFloat:5];
        shakeAnimation.autoreverses = YES;
        [_imageView.layer addAnimation:shakeAnimation forKey:nil];
    }
}


@end
