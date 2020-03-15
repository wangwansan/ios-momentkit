//
//  SDTimeLineRefreshHeader.m
//  GSD_WeiXin(wechat)
//
//  Created by gsd on 16/3/5.
//  Copyright © 2016年 GSD. All rights reserved.
//

/*
 
 *********************************************************************************
 *
 * GSD_WeiXin
 *
 * QQ交流群: 362419100(2群) 459274049（1群已满）
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios/GSD_WeiXin
 * 新浪微博:GSD_iOS
 *
 * 此“高仿微信”用到了很高效方便的自动布局库SDAutoLayout（一行代码搞定自动布局）
 * SDAutoLayout地址：https://github.com/gsdios/SDAutoLayout
 * SDAutoLayout视频教程：http://www.letv.com/ptv/vplay/24038772.html
 * SDAutoLayout用法示例：https://github.com/gsdios/SDAutoLayout/blob/master/README.md
 *
 *********************************************************************************
 
 */

//是否iPhoneX YES:iPhoneX屏幕 NO:传统屏幕
#define kIs_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define kStatusBarAndNavigationBarHeight (kIs_iPhoneX ? 88.f : 64.f)

#import "SDTimeLineRefreshHeader.h"

#define kSDTimeLineRefreshHeaderRotateAnimationKey @"RotateAnimationKey"

@implementation SDTimeLineRefreshHeader
{
    CABasicAnimation *_rotateAnimation;
    CGFloat criticalY;
}

+ (instancetype)refreshHeaderWithCenter:(CGPoint)center
{
    SDTimeLineRefreshHeader *header = [SDTimeLineRefreshHeader new];
    header.center = center;
    return header;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        criticalY = - kStatusBarAndNavigationBarHeight + 5;
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    self.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AlbumReflashIcon"]];
    self.bounds = imageView.bounds;
    [self addSubview:imageView];
    
    _rotateAnimation = [[CABasicAnimation alloc] init];
    _rotateAnimation.keyPath = @"transform.rotation.z";
    _rotateAnimation.fromValue = @0;
    _rotateAnimation.toValue = @(M_PI * 2);
    _rotateAnimation.duration = 1.0;
    _rotateAnimation.repeatCount = MAXFLOAT;
}

- (void)setRefreshState:(SDWXRefreshViewState)refreshState
{
    [super setRefreshState:refreshState];
    
    
    if (refreshState == SDWXRefreshViewStateRefreshing) {
        if (self.refreshingBlock) {
            self.refreshingBlock();
        }
        [self.layer addAnimation:_rotateAnimation forKey:kSDTimeLineRefreshHeaderRotateAnimationKey];
    } else if (refreshState == SDWXRefreshViewStateNormal) {
        [self.layer removeAnimationForKey:kSDTimeLineRefreshHeaderRotateAnimationKey];
        self.transform = CGAffineTransformIdentity;
        self.hidden = YES;
    } else if(refreshState == SDWXRefreshViewStateWillRefresh) {
        self.hidden = NO;
    }
}


- (void)updateRefreshHeaderWithOffsetY:(CGFloat)y
{
    
    CGFloat rotateValue = y / 50.0 * M_PI;
    
    if (y < criticalY) {
        if (self.scrollView.isDragging && self.refreshState != SDWXRefreshViewStateWillRefresh) {
            self.refreshState = SDWXRefreshViewStateWillRefresh;
        } else if (!self.scrollView.isDragging && self.refreshState == SDWXRefreshViewStateWillRefresh && (y < -110.f)) {
            self.refreshState = SDWXRefreshViewStateRefreshing;
        }
        y = criticalY;
    } else {
        if (self.refreshState == SDWXRefreshViewStateWillRefresh) {
            self.refreshState = SDWXRefreshViewStateNormal;
        }
        return;
    }
    
    if (self.refreshState == SDWXRefreshViewStateRefreshing) return;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, 0, -y);
    transform = CGAffineTransformRotate(transform, rotateValue);
    
    self.transform = transform;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (keyPath != kSDBaseRefreshViewObserveKeyPath) return;
    
    [self updateRefreshHeaderWithOffsetY:self.scrollView.contentOffset.y];
}

@end
