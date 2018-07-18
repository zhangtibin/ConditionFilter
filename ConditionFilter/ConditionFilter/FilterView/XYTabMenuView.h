//
//  XYTabMenuView.h
//  XYRenting
//
//  Created by 张体宾 on 2018/7/16.
//  Copyright © 2018年 Dreams of Ideal World Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYTabControl, XYTabMenuView;

@protocol XYTabMenuViewDelegate <NSObject>

- (void)tabMenuViewWillAppear:(XYTabMenuView *)view;
- (void)tabMenuViewWillDisappear:(XYTabMenuView *)view;

@end


@interface XYTabMenuView : UIView

@property (nonatomic, weak) id<XYTabMenuViewDelegate>delegate;

- (instancetype)initWithTabControl:(XYTabControl *)tabControl;

- (void)displayTabMenuViewWithMenuBar:(UIView *)menuBar;

- (void)reloadList;

- (void)dismiss;

@end
