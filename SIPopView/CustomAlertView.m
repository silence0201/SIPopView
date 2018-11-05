//
//  CustomAlertView.m
//  SIPopView
//
//  Created by Silence on 2018/11/5.
//  Copyright © 2018年 Silence. All rights reserved.
//

#import "CustomAlertView.h"

@implementation CustomAlertView

+ (instancetype)xib {
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    return nibs.firstObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.cornerRadius = 6.0f;
    self.layer.masksToBounds = YES;
}

@end
