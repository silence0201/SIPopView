//
//  SIPopView.m
//  SIPopView
//
//  Created by Silence on 2018/10/29.
//  Copyright © 2018年 Silence. All rights reserved.
//

#import "SIPopView.h"

@interface SIPopView ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *customView;

@property (nonatomic, assign) SIPopAnimationStyle     animationPopStyle;
@property (nonatomic, assign) SIDismissAnimationStyle animationDismissStyle;

@end

@implementation SIPopView

- (instancetype)initWithCustomView:(UIView *)customView popStyle:(SIPopAnimationStyle)popStyle dismissStyle:(SIDismissAnimationStyle)dismissStyle {
    if (!customView) return nil;
    if (self = [super init]) {
        _popBGAlpha = 0.5f;
        _customView = customView;
        _animationPopStyle = popStyle;
        _animationDismissStyle = dismissStyle;
        _popAnimationDuration = -0.1f;
        _dismissAnimationDuration = -0.1f;
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds));
        
        _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        _backgroundView.backgroundColor = [UIColor blackColor];
        _backgroundView.alpha = 0.0f;
        [self addSubview:_backgroundView];
        
        _contentView = [[UIView alloc] initWithFrame:self.bounds];
        _contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:_contentView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackground:)];
        tap.delegate = self;
        [_contentView addGestureRecognizer:tap];
        
        customView.center = _contentView.center;
        [_contentView addSubview:customView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    }
    return self;
}

#pragma mark Public
- (void)pop {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    __weak typeof(self)weakSelf = self;
    NSTimeInterval duration = [self popDuration:self.animationPopStyle];
    if (self.animationPopStyle == SIPopAnimationStyleNone) {
        if ([self isTransparent]) {
            self.backgroundView.backgroundColor = [UIColor clearColor];
        }else {
            self.backgroundView.alpha = 0.0;
        }
        
        [UIView animateWithDuration:duration animations:^{
            weakSelf.alpha = 1.0;
            if (![weakSelf isTransparent]) {
                weakSelf.backgroundView.alpha = weakSelf.popBGAlpha;
            }
        }];
    }else {
        if ([self isTransparent]) {
            self.backgroundView.backgroundColor = [UIColor clearColor];
        } else {
            self.backgroundView.alpha = 0.0;
            [UIView animateWithDuration:duration * 0.5 animations:^{
                weakSelf.backgroundView.alpha = weakSelf.popBGAlpha;
            }];
        }
        [self hanlePopAnimationWithDuration:duration];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf.popComplete) {
            strongSelf.popComplete();
        }
    });
    
}

- (void)dismiss {
    __weak typeof(self)weakSelf = self;
    NSTimeInterval duration = [self dismissDuration:self.animationDismissStyle];
    if (self.animationDismissStyle == SIDismissAnimationStyleNone) {
        [UIView animateWithDuration:duration animations:^{
            weakSelf.alpha = 0.0;
            weakSelf.backgroundView.alpha = 0.0;
        }];
    } else {
        if (![weakSelf isTransparent]) {
            [UIView animateWithDuration:duration * 0.5 animations:^{
                weakSelf.backgroundView.alpha = 0.0;
            }];
        }
        [self hanleDismissAnimationWithDuration:duration];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf.dismissComplete) {
            strongSelf.dismissComplete();
        }
        [strongSelf removeFromSuperview];
    });
}

- (void)tapBackground:(UITapGestureRecognizer *)tap{
    [self dismiss];
}

#pragma mark Animation
- (void)hanlePopAnimationWithDuration:(NSTimeInterval)duration {
    __weak typeof(self) ws = self;
    switch (self.animationPopStyle) {
        case SIPopAnimationStyleScale:
        {
            [self animationWithLayer:self.contentView.layer duration:duration values:@[@0.0, @1.2, @1.0]];
        }
            break;
        case SIPopAnimationStyleFromTop:
        case SIPopAnimationStyleFromBottom:
        case SIPopAnimationStyleFromLeft:
        case SIPopAnimationStyleFromRight:
        {
            CGPoint startPosition = self.contentView.layer.position;
            if (self.animationPopStyle == SIPopAnimationStyleFromTop) {
                self.contentView.layer.position = CGPointMake(startPosition.x, -startPosition.y);
            } else if (self.animationPopStyle == SIPopAnimationStyleFromBottom) {
                self.contentView.layer.position = CGPointMake(startPosition.x, CGRectGetMaxY(self.frame) + startPosition.y);
            } else if (self.animationPopStyle == SIPopAnimationStyleFromLeft) {
                self.contentView.layer.position = CGPointMake(-startPosition.x, startPosition.y);
            } else {
                self.contentView.layer.position = CGPointMake(CGRectGetMaxX(self.frame) + startPosition.x, startPosition.y);
            }
            
            [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                ws.contentView.layer.position = startPosition;
            } completion:nil];
        }
            break;
        default:
            break;
    }
}

- (void)hanleDismissAnimationWithDuration:(NSTimeInterval)duration {
    __weak typeof(self) ws = self;
    switch (self.animationDismissStyle) {
        case SIDismissAnimationStyleScale:
        {
            [self animationWithLayer:self.contentView.layer duration:duration values:@[@1.0, @0.66, @0.33, @0.01]];
        }
            break;
        case SIDismissAnimationStyleToTop:
        case SIDismissAnimationStyleToBottom:
        case SIDismissAnimationStyleToLeft:
        case SIDismissAnimationStyleToRight:
        {
            CGPoint startPosition = self.contentView.layer.position;
            CGPoint endPosition = self.contentView.layer.position;
            if (self.animationDismissStyle == SIDismissAnimationStyleToTop) {
                endPosition = CGPointMake(startPosition.x, -startPosition.y);
            } else if (self.animationDismissStyle == SIDismissAnimationStyleToBottom) {
                endPosition = CGPointMake(startPosition.x, CGRectGetMaxY(self.frame) + startPosition.y);
            } else if (self.animationDismissStyle == SIDismissAnimationStyleToLeft) {
                endPosition = CGPointMake(-startPosition.x, startPosition.y);
            } else {
                endPosition = CGPointMake(CGRectGetMaxX(self.frame) + startPosition.x, startPosition.y);
            }
            
            [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                ws.contentView.layer.position = endPosition;
            } completion:nil];
        }
            break;
        default:
            break;
    }
}

- (void)animationWithLayer:(CALayer *)layer duration:(CGFloat)duration values:(NSArray *)values{
    CAKeyframeAnimation *KFAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    KFAnimation.duration = duration;
    KFAnimation.removedOnCompletion = NO;
    KFAnimation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *valueArr = [NSMutableArray arrayWithCapacity:values.count];
    for (NSUInteger i = 0; i<values.count; i++) {
        CGFloat scaleValue = [values[i] floatValue];
        [valueArr addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(scaleValue, scaleValue, scaleValue)]];
    }
    KFAnimation.values = valueArr;
    KFAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    [layer addAnimation:KFAnimation forKey:nil];
}


#pragma mark Tools
- (BOOL)isTransparent {
    if (self.popBGAlpha <= 0) {
        return YES;
    }
    return NO;
}

- (NSTimeInterval)popDuration:(SIPopAnimationStyle)animationPopStyle{
    if (_popAnimationDuration >= 0) {
        return _popAnimationDuration;
    }
    NSTimeInterval defaultDuration = 0.0f;
    if (animationPopStyle == SIPopAnimationStyleNone) {
        defaultDuration = 0.2f;
    } else if (animationPopStyle == SIPopAnimationStyleScale) {
        defaultDuration = 0.3f;
    } else if (animationPopStyle == SIPopAnimationStyleFromTop ||
               animationPopStyle == SIPopAnimationStyleFromBottom ||
               animationPopStyle == SIPopAnimationStyleFromLeft ||
               animationPopStyle == SIPopAnimationStyleFromRight) {
        defaultDuration = 0.8f;
    }
    return defaultDuration;
}

- (NSTimeInterval)dismissDuration:(SIDismissAnimationStyle)animationPopStyle{
    if (_dismissAnimationDuration >= 0) {
        return _dismissAnimationDuration;
    }
    NSTimeInterval defaultDuration = 0.0f;
    if (animationPopStyle == SIDismissAnimationStyleNone) {
        defaultDuration = 0.2f;
    } else if (animationPopStyle == SIDismissAnimationStyleScale) {
        defaultDuration = 0.3f;
    } else if (animationPopStyle == SIDismissAnimationStyleToTop ||
               animationPopStyle == SIDismissAnimationStyleToBottom ||
               animationPopStyle == SIDismissAnimationStyleToLeft ||
               animationPopStyle == SIDismissAnimationStyleToRight) {
        defaultDuration = 0.8f;
    }
    return defaultDuration;
}

#pragma mark UIGestureRecognizer
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint location = [touch locationInView:_contentView];
    location = [_customView convertPoint:location fromView:_contentView];
    return ![_customView.layer containsPoint:location];
}

#pragma mark 监听横竖屏方向改变
- (void)statusBarOrientationChange:(NSNotification *)notification  {
    CGRect startCustomViewRect = self.customView.frame;
    self.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    self.backgroundView.frame = self.bounds;
    self.contentView.frame = self.bounds;
    self.customView.frame = startCustomViewRect;
    self.customView.center = self.center;
}

@end
