//
//  UIButton+Block.m
//  XYRenting
//
//  Created by 张体宾 on 2018/6/28.
//  Copyright © 2018年 Dreams of Ideal World Co., Ltd. All rights reserved.
//

#import "UIButton+Block.h"

#import <objc/runtime.h>

#define EMPTY_STRING(string) \
( [string isKindOfClass:[NSNull class]] || \
string == nil || [string isEqualToString:@""])


@implementation UIButton (Block)

static char ActionTag;

- (void)addAction:(ActionBlock)block {
    objc_setAssociatedObject(self, &ActionTag, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addAction:(ActionBlock)block forControlEvents:(UIControlEvents)controlEvents {
    objc_setAssociatedObject(self, &ActionTag, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(action:) forControlEvents:controlEvents];
}

- (void)action:(id)sender {
    ActionBlock block = (ActionBlock)objc_getAssociatedObject(self, &ActionTag);
    if (block) {
        block(self);
    }
}

+ (UIButton *)buttonWithTitle:(NSString *)title
                   titleColor:(UIColor *)titleColor
                   norImgName:(NSString *)norImgName
           highlightedImgName:(NSString *)highlightedImgName
                       action:(ActionBlock)block
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (!EMPTY_STRING(title)) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    if (titleColor != nil) {
        [button setTitleColor:titleColor forState:UIControlStateNormal];
    }
    if (!EMPTY_STRING(norImgName)) {
        [button setBackgroundImage:[UIImage imageNamed:norImgName] forState:UIControlStateNormal];
    }
    if (!EMPTY_STRING(highlightedImgName)) {
        [button setBackgroundImage:[UIImage imageNamed:highlightedImgName] forState:UIControlStateHighlighted];
    }
    
    [button addAction:^(UIButton *btn) {
        block(btn);
    } forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

@end
