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
#define IS_IOS7   ([[[UIDevice currentDevice] systemVersion] floatValue]>= 7.0?YES:NO)
//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define NavColor ([UIColor colorWithRed:237/255.0 green:20/255.0f blue:91/255.0f alpha:1.0f])

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UIBezierPath *path;
@end

@implementation ViewController{
    UITableView *_tableView;
    CALayer     *_layer;
    UIButton    *_shopCartbtn;
    CAShapeLayer *_shaperLayer;
    UILabel     *_cntLabel;
    NSInteger    _cnt;
    UIButton    *_btn;
    NSMutableArray *_dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [NSMutableArray array];
    [self addDataArray];
    [self customView];
    [self createTableView];
    [self bottomView];
}
-(void)addDataArray
{
    for (int i= 0; i<10; i++) {
        NSInteger index = random()%5+1;
        shopModel *model = [[shopModel alloc] init];
        model.shoppingIcon = [NSString stringWithFormat:@"test0%d.jpg",index];
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
}
-(void)bottomView
{
    UIColor *customColor  = [UIColor colorWithRed:237/255.0 green:20/255.0 blue:91/255.0 alpha:1.0f];
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
    //    NSArray *arr = @[@"取消",@"确定"];
    //    for (int i=0; i<2; i++) {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    view.alpha = 0.8f;
    [bottomView addSubview:view];
    
    _btn = [[UIButton alloc] initWithFrame:CGRectMake(1*(SCREEN_WIDTH - 60), 0, 50, 50)];
//    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [_btn setImage:[UIImage imageNamed:@"TabCartSelected@2x.png"] forState:UIControlStateNormal];
    [bottomView addSubview:_btn];
    [self.view addSubview:bottomView];
    // label
    _cntLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 30), 10, 13, 13)];
    _cntLabel.textColor = customColor;
    _cntLabel.textAlignment = NSTextAlignmentCenter;
    _cntLabel.font = [UIFont boldSystemFontOfSize:11];
    _cntLabel.backgroundColor = [UIColor whiteColor];
    _cntLabel.layer.cornerRadius = CGRectGetHeight(_cntLabel.bounds)/2;
    _cntLabel.layer.masksToBounds = YES;
    _cntLabel.layer.borderWidth = 1.0f;
    _cntLabel.layer.borderColor = customColor.CGColor;
    [bottomView addSubview:_cntLabel];
    if (_cnt == 0) {
        _cntLabel.hidden = YES;
    }

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
//        _btn.enabled = NO;
        _layer = [CALayer layer];
        _layer.contents = (id)imageView.layer.contents;
        
        _layer.contentsGravity = kCAGravityResizeAspectFill;
        _layer.bounds = rect;
        [_layer setCornerRadius:CGRectGetHeight([_layer bounds]) / 2];
        _layer.masksToBounds = YES;
        // 导航64
        _layer.position = CGPointMake(imageView.center.x, CGRectGetMidY(rect)+64);
//        [_tableView.layer addSublayer:_layer];
        [self.view.layer addSublayer:_layer];
        self.path = [UIBezierPath bezierPath];
        [_path moveToPoint:_layer.position];
//        (SCREEN_WIDTH - 60), 0, 50, 50)
        [_path addQuadCurveToPoint:CGPointMake(SCREEN_WIDTH - 40, SCREEN_HEIGHT-40) controlPoint:CGPointMake(SCREEN_WIDTH/2,rect.origin.y-80)];
//        [_path addLineToPoint:CGPointMake(SCREEN_WIDTH-40, 30)];
    }
    [self groupAnimation];
}
-(void)groupAnimation
{
    _tableView.userInteractionEnabled = NO;
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
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    //    [anim def];
    if (anim == [_layer animationForKey:@"group"]) {
         _tableView.userInteractionEnabled = YES;
//        _btn.enabled = YES;
        [_layer removeFromSuperlayer];
        _layer = nil;
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
        [_btn.layer addAnimation:shakeAnimation forKey:nil];
    }
}

@end
