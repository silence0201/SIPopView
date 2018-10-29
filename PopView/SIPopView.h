//
//  SIPopView.h
//  SIPopView
//
//  Created by Silence on 2018/10/29.
//  Copyright © 2018年 Silence. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CompleteBlock)(void);

typedef NS_ENUM(NSInteger,SIPopAnimationStyle) {
    SIPopAnimationStyleNone = 0,
    SIPopAnimationStyleScale,
    SIPopAnimationStyleFromTop,
    SIPopAnimationStyleFromBottom,
    SIPopAnimationStyleFromLeft,
    SIPopAnimationStyleFromRight,
};

typedef NS_ENUM(NSInteger,SIDismissAnimationStyle) {
    SIDismissAnimationStyleNone = 0,
    SIDismissAnimationStyleScale,
    SIDismissAnimationStyleToTop,
    SIDismissAnimationStyleToBottom,
    SIDismissAnimationStyleToLeft,
    SIDismissAnimationStyleToRight,
};

@interface SIPopView : UIView

@property (assign, nonatomic) CGFloat popBGAlpha;

@property (assign, nonatomic) CGFloat popAnimationDuration;
@property (assign, nonatomic) CGFloat dismissAnimationDuration;

@property (nonatomic, copy) CompleteBlock popComplete;
@property (nonatomic, copy) CompleteBlock dismissComplete;

- (instancetype)initWithCustomView:(UIView *)customView
                          popStyle:(SIPopAnimationStyle)popStyle
                      dismissStyle:(SIDismissAnimationStyle)dismissStyle;

- (void)pop;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
