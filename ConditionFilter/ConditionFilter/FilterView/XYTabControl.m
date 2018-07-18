//
//  XYTabControl.m
//  XYRenting
//
//  Created by 张体宾 on 2018/7/16.
//  Copyright © 2018年 Dreams of Ideal World Co., Ltd. All rights reserved.
//

#import "XYTabControl.h"

@interface XYTabControl ()

@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, assign, readwrite) TabControlType tabControlType;
/** 私有属性用于自定义视图 主动移除筛选列表  */
@property (nonatomic, copy) void (^didDismissTabMenuBar)(void);

@end

@implementation XYTabControl

+ (instancetype)tabControlWithTitle:(NSString *)title type:(TabControlType)type
{
    XYTabControl *tabControl = [[XYTabControl alloc] init];
    tabControl.title = title;
    tabControl.tabControlType = type;
    [tabControl setTitle:title forState:UIControlStateNormal];
    tabControl.titleLabel.font =  [UIFont systemFontOfSize:14];
    tabControl.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [tabControl setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [tabControl setImage:[UIImage imageNamed:@"common_arrow_down"] forState:UIControlStateNormal];
    [tabControl setImage:[UIImage imageNamed:@"common_arrow_up"] forState:UIControlStateSelected];
    
    return tabControl;
}

- (void)adjustFrame {
    
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.imageView.bounds.size.width + 2, 0, self.imageView.bounds.size.width + 10)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.titleLabel.bounds.size.width + 10, 0, -self.titleLabel.bounds.size.width + 2)];
}

- (void)adjustTitle:(NSString *)title textColor:(UIColor *)color {
    if (![title isKindOfClass:[NSString class]]) return;
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitleColor:color forState:UIControlStateNormal];
    [self adjustFrame];
    // 移除筛选列表
    if(self.didDismissTabMenuBar){
        self.didDismissTabMenuBar();
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
