//
//  XYTabMenuBar.h
//  XYRenting
//
//  Created by 张体宾 on 2018/7/16.
//  Copyright © 2018年 Dreams of Ideal World Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYTabControl, XYTabMenuBar;

@protocol XYTabMenuBarDelegate <NSObject>

- (void)tabMenuViewWillAppear:(XYTabMenuBar *)view tabControl:(XYTabControl *)tabControl;
- (void)tabMenuViewWillDisappear:(XYTabMenuBar *)view tabControl:(XYTabControl *)tabControl;

@end


@interface XYTabMenuBar : UIView

@property (nonatomic, strong) NSArray <XYTabControl *>*tabControls;
@property (nonatomic, weak) id<XYTabMenuBarDelegate>delegate;

- (instancetype)initWithTabControls:(NSArray<XYTabControl *>*)tabControls;

- (void)reloadMenus;

@end
