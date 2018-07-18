//
//  XYTabMenuBar.m
//  XYRenting
//
//  Created by 张体宾 on 2018/7/16.
//  Copyright © 2018年 Dreams of Ideal World Co., Ltd. All rights reserved.
//

#import "XYTabMenuBar.h"

#import "XYTabControl.h"
#import "XYTabMenuView.h"
#import "SeperateLine.h"

@interface XYTabMenuBar () <XYTabMenuViewDelegate>

@property (nonatomic, assign) CGRect orginFrame;
@property (nonatomic, assign) CGRect showFilterFrame;
@property (nonatomic, strong) SeperateLine *bottomLine;
@property (nonatomic, strong) NSMutableArray *menus;
@property (nonatomic, weak) XYTabControl *currentTab;
@property (nonatomic, weak) XYTabMenuView *showMenuView;

@end


@implementation XYTabMenuBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 4.0;
        [self addSubview:self.bottomLine];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.frame.size.width/self.tabControls.count;
    [self.tabControls enumerateObjectsUsingBlock:^(XYTabControl * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XYTabControl *tabControl = obj;
        tabControl.frame = CGRectMake(idx * width, 0, width, self.frame.size.height);
        [tabControl adjustFrame];
    }];
    if (!self.orginFrame.size.width) {
        self.orginFrame = self.frame;
    }
    self.showFilterFrame = CGRectMake(0, self.frame.origin.y, [UIScreen mainScreen].bounds.size.width, self.frame.size.height);
    self.bottomLine.frame = CGRectMake(0, self.frame.size.height - 0.6, self.frame.size.width, 0.6);
    
}

- (instancetype)initWithTabControls:(NSArray<XYTabControl *>*)tabControls
{
    if (self = [super init]) {
        _tabControls = tabControls;
        [self initItems];
    }
    return self;
}

- (void)initItems {
    __weak typeof(self) weakSelf = self;
    [self.tabControls enumerateObjectsUsingBlock:^(XYTabControl * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [weakSelf addSubview:obj];
        
        [obj addTarget:self action:@selector(tabControlDidClick:) forControlEvents:UIControlEventTouchUpInside];
        void (^didDismissTabMenuBar)(void) = ^{
            [weakSelf dismiss];
        };
        [obj setValue:didDismissTabMenuBar forKeyPath:@"didDismissTabMenuBar"];
        
        XYTabMenuView *menuView = [[XYTabMenuView alloc] initWithTabControl:obj];
        menuView.delegate = self;
        [weakSelf.menus addObject:menuView];
        
    }];
}

- (void)setTabControls:(NSArray<XYTabControl *> *)tabControls {
    if (_tabControls.count) {
        return;
    }
    _tabControls = tabControls;
    [self initItems];
}

- (void)tabControlDidClick:(XYTabControl *)tabControl
{
    [self.tabControls enumerateObjectsUsingBlock:^(XYTabControl * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isEqual:tabControl]) {
            obj.selected = NO;
        }
    }];
    self.currentTab = tabControl;
    NSUInteger index = [self.tabControls indexOfObject:tabControl];
    XYTabMenuView *showMenuView = self.menus[index];
    [self.menus enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XYTabMenuView *menuView = obj;
        if (![menuView isEqual:showMenuView]) {
            [menuView dismiss];
        }
    }];
    self.showMenuView = showMenuView;
    [showMenuView displayTabMenuViewWithMenuBar:self];
}

- (void)reloadMenus {
    [self.showMenuView reloadList];
}

- (void)dismiss {
    //  将其他的菜单移除
    [self.menus enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XYTabMenuView *menuView = obj;
        [menuView dismiss];
    }];
}

- (void)adjustFrameWithShowDetail:(BOOL)show {
    if (show) {
        [UIView animateWithDuration:0.25 animations:^{
            self.frame = self.showFilterFrame;
            self.layer.cornerRadius = 0;
            self.currentTab.selected = YES;
            self.bottomLine.hidden = NO;
        }];
    }else {
        [UIView animateWithDuration:0.25 animations:^{
            self.frame = self.orginFrame;
            self.layer.cornerRadius = 4;
            self.currentTab.selected = NO;
            self.bottomLine.hidden = YES;
        }];
    }
}

- (void)tabMenuViewWillAppear:(XYTabMenuView *)view {
    [self adjustFrameWithShowDetail:YES];
    if ([self.delegate respondsToSelector:@selector(tabMenuViewWillAppear:tabControl:)]) {
        [self.delegate tabMenuViewWillAppear:self tabControl:self.currentTab];
    }
}

- (void)tabMenuViewWillDisappear:(XYTabMenuView *)view {
    [self adjustFrameWithShowDetail:NO];
    if ([self.delegate respondsToSelector:@selector(tabMenuViewWillDisappear:tabControl:)]) {
        [self.delegate tabMenuViewWillDisappear:self tabControl:self.currentTab];
    }
}


- (SeperateLine *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[SeperateLine alloc] init];
    }
    return _bottomLine;
}

#pragma mark - 懒加载
- (NSMutableArray *)menus {
    
    if (!_menus) {
        _menus = [NSMutableArray arrayWithCapacity:0];
    }
    return _menus;
}


- (void)dealloc {
    NSLog(@"%s", __func__);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
