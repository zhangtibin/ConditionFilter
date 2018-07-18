//
//  XYTabControl.h
//  XYRenting
//
//  Created by 张体宾 on 2018/7/16.
//  Copyright © 2018年 Dreams of Ideal World Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TabControlType) {
    TabControlTypeDefault = 0,  //默认列表形式
    TabControlTypeCustom           //自定义形式
};

@class XYItemModel;
@interface XYTabControl : UIButton

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, assign, readonly) TabControlType tabControlType;
@property (nonatomic, copy) UIView *(^displayCustomWithMenu)(void);
@property (nonatomic, strong) NSArray <XYItemModel *>*ListDataSource;
@property (nonatomic, copy) void(^didSelectedMenuResult)(NSInteger index, XYItemModel *selecModel);

+ (instancetype)tabControlWithTitle:(NSString *)title type:(TabControlType)type;

- (void)adjustFrame;

/** 用于调整 自定义视图选中时文字的显示 */
- (void)adjustTitle:(NSString *)title textColor:(UIColor *)color;

@end
