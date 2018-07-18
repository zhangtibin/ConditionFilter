//
//  UIColor+HexString.h
//  XYRenting
//
//  Created by 张体宾 on 2018/6/7.
//  Copyright © 2018年 Dreams of Ideal World Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexString)

+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor *)colorWithHexString:(NSString *) hexString alpha:(CGFloat)alpha;
+ (UIColor *)colorWithIntValue:(int)intValue;
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIColor *)randomColor;

@end
