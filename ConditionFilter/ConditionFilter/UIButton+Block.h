//
//  UIButton+Block.h
//  XYRenting
//
//  Created by 张体宾 on 2018/6/28.
//  Copyright © 2018年 Dreams of Ideal World Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ActionBlock)(UIButton *btn);

@interface UIButton (Block)

- (void)addAction:(ActionBlock)block;

- (void)addAction:(ActionBlock)block forControlEvents:(UIControlEvents)controlEvents;

+ (UIButton *)buttonWithTitle:(NSString *)title
                   titleColor:(UIColor *)titleColor
                   norImgName:(NSString *)norImgName
           highlightedImgName:(NSString *)highlightedImgName
                       action:(ActionBlock)block;

@end
