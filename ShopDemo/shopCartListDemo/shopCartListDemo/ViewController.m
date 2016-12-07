//
//  ViewController.m
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

#import "ViewController.h"
#import "shopCartCell.h"
#import "shopModel.h"
#import "ShoppingCartBtn.h"
#define IS_IOS7   ([[[UIDevice currentDevice] systemVersion] floatValue]>= 7.0?YES:NO)
//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define NavColor ([UIColor colorWithRed:237/255.0 green:20/255.0f blue:91/255.0f alpha:1.0f])

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UIBezierPath *path;
@end

@implementation ViewController{
    UITableView     *_tableView;
    CALayer         *_layer;
    UIButton        *_shopCartbtn;
    NSInteger       _cnt;      // 记录个数
    ShoppingCartBtn   *_btn;
    NSMutableArray *_dataSource;
    BOOL            _animType; // 动画类型
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [NSMutableArray array];
    [self addDataArray];
    [self customView];
    [self createTableView];
    [self bottomView];
}
#pragma mark - 添加数据
-(void)addDataArray
{
    for (int i= 0; i<10; i++) {
        NSInteger index = arc4random()%5+1;
        shopModel *model = [[shopModel alloc] init];
        model.shoppingIcon = [NSString stringWithFormat:@"test0%ld.jpg",index];
        model.shoppingName = [NSString stringWithFormat:@"商品%d号",i];
        [_dataSource addObject:model];
    }
}
#pragma mark - 自定义导航栏
-(void)customView
{
    self.navigationController.navigationBarHidden = YES;
    CGFloat h = IS_IOS7?64:44;
    CGFloat subH = IS_IOS7?20:0;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, h)];
    view.backgroundColor = NavColor;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, subH, SCREEN_WIDTH, 44)];
    if (!IS_IOS7) titleLabel.backgroundColor = NavColor;
    titleLabel.text = @"shopCart";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:21];
    [view addSubview:titleLabel];
    [self.view addSubview:view];
    // 切换动画
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(SCREEN_WIDTH - 60, 20, 50, 44);
    [rightBtn setTitle:@"动画1" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [rightBtn addTarget:self action:@selector(switchType:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:rightBtn];
}
-(void)bottomView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    view.alpha = 0.8f;
    [bottomView addSubview:view];
    // create shoppingCartBtn
    _btn = [[ShoppingCartBtn alloc] initWithFrame:CGRectMake(1*(SCREEN_WIDTH - 60), 0, 50, 50)];
    [bottomView addSubview:_btn];
        [self.view addSubview:bottomView];
    [_btn setBtnAction:@selector(goShoppingCart) delegate:self];
}

-(void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"shopCartCell" bundle:nil] forCellReuseIdentifier:@"shopCartCell"];
    _tableView.delegate =self;
    _tableView.dataSource = self;
}
#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"shopCartCell";
    shopCartCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[shopCartCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    shopModel *model = _dataSource[indexPath.row];
    [cell refreshCellWithModel:model];
    cell.shopCartBlock = ^(UIImageView *imageView){
         CGRect rect = [tableView rectForRowAtIndexPath:indexPath];
        rect.origin.y = rect.origin.y - [_tableView contentOffset].y;
        CGRect headRect = imageView.frame;
        headRect.origin.y = rect.origin.y+headRect.origin.y;
        [self startAnimationWithRect:headRect ImageView:imageView];
    };
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
-(void)startAnimationWithRect:(CGRect)rect ImageView:(UIImageView *)imageView
{
    if (!_layer) {
        _layer = [CALayer layer];
        _layer.contents = (id)imageView.layer.contents;
        
        _layer.contentsGravity = kCAGravityResizeAspectFill;
        _layer.bounds = rect;
        [_layer setCornerRadius:CGRectGetHeight([_layer bounds]) / 2];
        _layer.masksToBounds = YES;
        // 原View中心点
        _layer.position = CGPointMake(imageView.center.x, CGRectGetMidY(rect)+64);
        [self.view.layer addSublayer:_layer];
        self.path = [UIBezierPath bezierPath];
        // 起点
        [_path moveToPoint:_layer.position];
        // 终点
        if (_animType) { // 直线
             [_path addLineToPoint:CGPointMake(SCREEN_WIDTH - 40, SCREEN_HEIGHT-40)];
        }else{
             [_path addQuadCurveToPoint:CGPointMake(SCREEN_WIDTH - 40, SCREEN_HEIGHT-40) controlPoint:CGPointMake(SCREEN_WIDTH/2,rect.origin.y-80)];
        }
    }
    [self groupAnimation];
}
-(void)groupAnimation
{
    _tableView.userInteractionEnabled = NO;
    if (_animType) { // 动画2
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        animation.path = _path.CGPath;
        CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.duration=0.3f;
        rotationAnimation.repeatCount = INFINITY;
        rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
        rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        
        CABasicAnimation *narrowAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        rotationAnimation.fromValue = [NSNumber numberWithFloat:1];
        narrowAnimation.duration = 1.0f;
        narrowAnimation.toValue = [NSNumber numberWithFloat:0.1];
        
        narrowAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        // group
        CAAnimationGroup *groups = [CAAnimationGroup animation];
        groups.animations = @[animation,rotationAnimation,narrowAnimation];
        groups.duration = 1.0f;
        groups.removedOnCompletion=NO;
        groups.fillMode=kCAFillModeForwards;
        groups.delegate = self;
        [_layer addAnimation:groups forKey:@"group"];
    }else{ // 动画1
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
        narrowAnimation.toValue = [NSNumber numberWithFloat:0.3f];
        
        narrowAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        
        CAAnimationGroup *groups = [CAAnimationGroup animation];
        groups.animations = @[animation,expandAnimation,narrowAnimation];
        groups.duration = 2.0f;
        groups.removedOnCompletion=NO;
        groups.fillMode=kCAFillModeForwards;
        groups.delegate = self;
        [_layer addAnimation:groups forKey:@"group"];
    }
}
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (anim == [_layer animationForKey:@"group"]) {
         _tableView.userInteractionEnabled = YES;
        [_layer removeFromSuperlayer];
        _layer = nil;
        _cnt++;
        [_btn setCnt:_cnt];
     
    }
}
#pragma mark - btn click
-(void)goShoppingCart
{

}
-(void)switchType:(UIButton *)btn
{
    _animType = !_animType;
    if (_animType) {
        [btn setTitle:@"动画2" forState:UIControlStateNormal];
    }else{
        [btn setTitle:@"动画1" forState:UIControlStateNormal];
    }
}
@end
