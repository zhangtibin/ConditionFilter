//
//  ViewController.m
//  ConditionFilter
//
//  Created by 张体宾 on 2018/7/18.
//  Copyright © 2018年 Dreams of Ideal World Co., Ltd. All rights reserved.
//

#import "ViewController.h"

#import "XYTabMenuBar.h"
#import "XYTabControl.h"
#import "XYItemModel.h"
#import "XYMoreFilterView.h"

@interface ViewController () <XYTabMenuBarDelegate, XYMoreFilterViewDelegate>

@property (nonatomic, strong) XYTabMenuBar *tabMenuBar;
@property (nonatomic, strong) NSMutableArray *locationList;//按地区
@property (nonatomic, strong) NSMutableArray *houseList;//按出租类型
@property (nonatomic, strong) NSMutableArray *commissionList;//按租金
@property (nonatomic, strong) NSMutableArray *moreList;//更多筛选
@property (nonatomic, strong) XYMoreFilterView *moreFilterView;
@property (nonatomic, strong) XYTabControl *customTab;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor brownColor];
    
    [self configureFilterData];
    
    [self initFilterView];
}

- (void)initFilterView {
    XYTabControl *locationControl = [XYTabControl tabControlWithTitle:@"全上海" type:TabControlTypeDefault];
    locationControl.ListDataSource = self.locationList;
    locationControl.didSelectedMenuResult = ^(NSInteger index, XYItemModel *selecModel) {
        NSLog(@"区域 === %@", selecModel.displayText);
    };
    
    XYTabControl *houseControl = [XYTabControl tabControlWithTitle:@"整租" type:TabControlTypeDefault];
    houseControl.ListDataSource = self.houseList;
    houseControl.didSelectedMenuResult = ^(NSInteger index, XYItemModel *selecModel) {
        NSLog(@"房屋类型 === %@", selecModel.displayText);
    };
    
    XYTabControl *commissionControl = [XYTabControl tabControlWithTitle:@"租金" type:TabControlTypeDefault];
    commissionControl.ListDataSource = self.commissionList;
    commissionControl.didSelectedMenuResult = ^(NSInteger index, XYItemModel *selecModel) {
        NSLog(@"租金范围 === %@", selecModel.displayText);
    };
    
    XYTabControl *moreControl = [XYTabControl tabControlWithTitle:@"更多" type:TabControlTypeCustom];
    moreControl.ListDataSource = self.locationList;
    moreControl.didSelectedMenuResult = ^(NSInteger index, XYItemModel *selecModel) {
        NSLog(@"更多 === %@", selecModel.displayText);
    };
    moreControl.displayCustomWithMenu = ^UIView *{
        return self.moreFilterView;
    };
    self.customTab = moreControl;
    self.tabMenuBar = [[XYTabMenuBar alloc] initWithTabControls:@[locationControl, houseControl, commissionControl, self.customTab]];
    _tabMenuBar.delegate = self;
    _tabMenuBar.frame = CGRectMake(0, 64, self.view.frame.size.width, 45);
    _tabMenuBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tabMenuBar];
}

- (void)configureFilterData {
    self.locationList = [NSMutableArray arrayWithCapacity:1];
    self.houseList = [NSMutableArray arrayWithCapacity:1];
    self.commissionList = [NSMutableArray arrayWithCapacity:1];
    self.moreList = [NSMutableArray arrayWithCapacity:1];
    
    NSArray *locationArr = @[@"区域", @"地铁"];
    
    //读取 Plist 文件
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"LocationFilter" ofType:@"plist"];
    NSMutableDictionary *locationDataDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSLog(@"%@", locationDataDic);//直接打印数据。
    
    for (int i = 0; i < locationArr.count; i++) {//一级列表
        XYItemModel *model;
        model = [XYItemModel modelWithText:[NSString stringWithFormat:@" %@", [locationArr objectAtIndex:i]] currentID:[NSString stringWithFormat:@"%d", i] isSelect:i == 0];
        NSMutableArray *temp2 = [NSMutableArray array];
        NSArray *dataArr = [[locationDataDic objectForKey:[locationArr objectAtIndex:i]] objectForKey:@"KeyList"];
        for (int j = 0; j < dataArr.count; j++) {//二级列表
            
            XYItemModel *secondModel;
            if (j == 0) {
                secondModel = [XYItemModel modelWithText:[NSString stringWithFormat:@"不限"] currentID:[NSString stringWithFormat:@"%d", j] isSelect:j == 0];
            }
            else {
                secondModel = [XYItemModel modelWithText:[NSString stringWithFormat:@"%@", [dataArr objectAtIndex:j]] currentID:[NSString stringWithFormat:@"%d", j] isSelect:j == 0];
                NSMutableArray *temp = [NSMutableArray arrayWithCapacity:0];
                for (int k = 0; k < [[[locationDataDic objectForKey:[locationArr objectAtIndex:i]] objectForKey:[dataArr objectAtIndex:j]] count]; k++) { //三级列表
                    XYItemModel *thirdModel;
                    if (k == 0) {
                        thirdModel = [XYItemModel modelWithText:[NSString stringWithFormat:@"不限"] currentID:[NSString stringWithFormat:@"%d", k] isSelect:k == 0];
                    }
                    else {
                        thirdModel = [XYItemModel modelWithText:[[[locationDataDic objectForKey:[locationArr objectAtIndex:i]] objectForKey:[dataArr objectAtIndex:j]] objectAtIndex:k] currentID:[NSString stringWithFormat:@"%d", k] isSelect:k == 0];
                    }
                    [temp addObject:thirdModel];
                }
                secondModel.dataSource = temp;
            }
            [temp2 addObject:secondModel];
        }
        model.dataSource = temp2;
        [self.locationList addObject:model];
    }
    
    //出租类型
    NSArray *houseArr = @[@"不限", @"整租", @"合租"];
    for (int i = 0; i < houseArr.count; i++) {
        BOOL select = i == 0;
        XYItemModel *model = [XYItemModel modelWithText:[NSString stringWithFormat:@" %@", [houseArr objectAtIndex:i]] currentID:[NSString stringWithFormat:@"%d", i] isSelect:select];
        [self.houseList addObject:model];
    }
    //租金
    NSArray *commissionArr = @[@"不限", @"1500以下", @"1500~2500元", @"2500~3500元", @"3500~5000元", @"5000~8000元", @"8000~10000元", @"10000元以上"];
    for (int i = 0; i < commissionArr.count; i++) {
        BOOL select = i == 0;
        XYItemModel *model = [XYItemModel modelWithText:[NSString stringWithFormat:@" %@", [commissionArr objectAtIndex:i]] currentID:[NSString stringWithFormat:@"%d", i] isSelect:select];
        [self.commissionList addObject:model];
    }
    
}

- (void)tabMenuViewWillAppear:(XYTabMenuBar *)view tabControl:(XYTabControl *)tabControl {
    if ([tabControl.title isEqualToString:@"全上海"]) {
        // 模拟每次点击时重新获取最新数据   网络请求返回数据
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            tabControl.ListDataSource = self.locationList;
            [self.tabMenuBar reloadMenus];
            
        });
    }
}

- (void)tabMenuViewWillDisappear:(XYTabMenuBar *)view tabControl:(XYTabControl *)tabControl {
    NSLog(@"");
}

- (void)filterMoreCondition:(NSDictionary *)conditions {
    NSLog(@"%@", conditions);
    //    [_moreFilterView dismiss];
    [self.customTab adjustTitle:@"更多" textColor:[UIColor colorWithRed:(87)/255.0 green:(33)/255.0 blue:(129)/255.0 alpha:1.0]];
}


- (XYMoreFilterView *)moreFilterView {
    if (!_moreFilterView) {
        _moreFilterView = [[XYMoreFilterView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*0.6 + 100)];
        _moreFilterView.backgroundColor = [UIColor whiteColor];
        _moreFilterView.delegate = self;
    }
    return _moreFilterView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
