//
//  XYTabMenuView.m
//  XYRenting
//
//  Created by 张体宾 on 2018/7/16.
//  Copyright © 2018年 Dreams of Ideal World Co., Ltd. All rights reserved.
//

#import "XYTabMenuView.h"

#import "XYTabControl.h"
#import "XYItemModel.h"

#define kScreenWidth                      [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight                     [[UIScreen mainScreen] bounds].size.height

@interface XYTabMenuView () <UITableViewDelegate, UITableViewDataSource>
{
@private
    /** 保存 选择的数据(行数) */
    NSInteger selects[3];
}
@property (nonatomic, strong) XYTabControl *tabControl;
@property (nonatomic, strong) NSArray *oneListDataSource;
@property (nonatomic, strong) NSArray *twoListDataSource;
@property (nonatomic, strong) NSArray *threeListDataSource;
@property (nonatomic, assign) NSInteger firstSelectRow;
@property (nonatomic, assign) NSInteger secondSelectRow;
@property (nonatomic, assign) NSInteger lastSelectRow;
@property (nonatomic, strong) NSArray *tableViewArr;
@property (nonatomic, assign) BOOL flag;//标记，用于记录是否是恢复上次的选中


@end

@implementation XYTabMenuView

- (instancetype)initWithTabControl:(XYTabControl *)tabControl {
    if (self = [super init]) {
        self.tabControl = tabControl;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.6];
        if (tabControl.tabControlType == TabControlTypeDefault) {
            [self adjustTableViewsWithCount:1];
        }
        for (int i = 0; i < 3; i++) {
            selects[i] = -1;
        }
    }
    return self;
}

- (void)displayTabMenuViewWithMenuBar:(UIView *)menuBar
{
    if (!self.superview) {
        // 初始位置 设置
        CGFloat x = 0.f;
        CGFloat y = menuBar.frame.origin.y + menuBar.frame.size.height;
        CGFloat w = kScreenWidth;
        CGFloat h = kScreenHeight - y;
        self.frame = CGRectMake(x, y, w, h);
        if (self.tabControl.tabControlType == TabControlTypeCustom) {
            if (self.tabControl.displayCustomWithMenu) {
                UIView *customView = self.tabControl.displayCustomWithMenu();
                [self addSubview:customView];
            }
        }else {
            [self adjustTableViewsWithCount:1];
            [self resetSelect];
        }
        [menuBar.superview addSubview:self];
        if ([self.delegate respondsToSelector:@selector(tabMenuViewWillAppear:)]) {
            [self.delegate tabMenuViewWillAppear:self];
        }
    }else {
        [self dismiss];
    }
    
}

#pragma mark - 重置选中
- (void)resetSelect {
    
    self.flag = NO;
    // 三级列表选中
    if(self.threeListDataSource.count && selects[2] >= 0) {
        [self adjustTableViewsWithCount:3];
        // 选中TableView某一行
        [self selectOldRecord:0];
        [self selectOldRecord:1];
        [self selectOldRecord:2];
        // 如果是两级列表 并且选中了第二例，则显示选中状态。
        [self resetOldSelectWithDataSource:self.oneListDataSource selectRow:selects[0]];
        [self resetOldSelectWithDataSource:self.twoListDataSource selectRow:selects[1]];
        [self resetOldSelectWithDataSource:self.threeListDataSource selectRow:selects[2]];
        
        // 两级列表选中
    }else if (selects[2] < 0 && self.twoListDataSource.count && selects[1] >= 0) {
        [self adjustTableViewsWithCount:2];
        // 选中TableView某一行
        [self selectOldRecord:0];
        [self selectOldRecord:1];
        // 如果是两级列表 并且选中了第二例，则显示选中状态。
        [self resetOldSelectWithDataSource:self.oneListDataSource selectRow:selects[0]];
        [self resetOldSelectWithDataSource:self.twoListDataSource selectRow:selects[1]];
        
    }else {
        // 如果是一级列表，直接返回
        if (!self.twoListDataSource.count)  return;
        [self resetOldSelectWithDataSource:self.oneListDataSource selectRow:0];
        [self.tableViewArr[0] setContentOffset:CGPointZero];
        [self.tableViewArr[0] reloadData];
    }
}

- (void)selectOldRecord:(NSInteger)idx {
    self.flag = YES;
    // 选中TableView某一行
    UITableView *tableView = self.tableViewArr[idx];
    if ([tableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [tableView.delegate tableView:tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:selects[idx] inSection:0]];
    }
    [tableView reloadData];
}

#pragma mark - 重置TableView的 位置
-(void)adjustTableViewsWithCount:(int)count{
    
    [self.tableViewArr enumerateObjectsUsingBlock:^(UITableView *tableView, NSUInteger idx, BOOL * _Nonnull stop) {
        tableView.frame = CGRectZero;
    }];
    for (int i = 0; i < count; i++) {
        UITableView *tableView = self.tableViewArr[i];
        CGRect adjustFrame = self.frame;
        adjustFrame.size.width = kScreenWidth / count ;
        adjustFrame.origin.x = adjustFrame.size.width * i;
        adjustFrame.size.height = adjustFrame.size.height * 0.6;
        adjustFrame.origin.y = 0;
        
        tableView.frame = adjustFrame;
    }
}

- (void)reloadList {
    [self.tableViewArr enumerateObjectsUsingBlock:^(UITableView *tableView, NSUInteger idx, BOOL * _Nonnull stop) {
        [tableView reloadData];
    }];
}

#pragma Mark - 选中的列表切换时，重置选中状态
- (void)resetOldSelectWithDataSource:(NSArray *)dataSource selectRow:(NSInteger) row {
    [dataSource enumerateObjectsUsingBlock:^(XYItemModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        model.seleceted = NO;
    }];
    XYItemModel *selectModel = dataSource[row];
    selectModel.seleceted = YES;
}

#pragma mark - 重置actionTitle 的文字
- (void)resetActionTitle:(XYItemModel *)selectModel selectRow:(NSInteger)row {
    // 表明只有一层数据。。选中第一行则恢复初始的title. 反正显示选中的数据
    if(row == 0) {
        [self.tabControl setTitle:self.tabControl.title forState:UIControlStateNormal];
        [self.tabControl setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else {
        [self.tabControl setTitle:selectModel.displayText forState:UIControlStateNormal];
        [self.tabControl setTitleColor:[UIColor colorWithRed:(87)/255.0 green:(33)/255.0 blue:(129)/255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    [self.tabControl adjustFrame];
}

- (void)dismiss {
    if (self.superview) {
        [self endEditing:YES];
        if ([self.delegate respondsToSelector:@selector(tabMenuViewWillDisappear:)]) {
            [self.delegate tabMenuViewWillDisappear:self];
        }
        [self removeFromSuperview];
    }
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableViewArr[0]) {
        self.oneListDataSource = self.tabControl.ListDataSource;
        return self.tabControl.ListDataSource.count;
    } else if (tableView == self.tableViewArr[1]) {
        // 根据第一层选中的索引获取包含的第二层数组
        XYItemModel *firstModel =self.tabControl.ListDataSource[self.firstSelectRow];
        self.twoListDataSource = firstModel.dataSource;
        return firstModel.dataSource.count;
    } else {
        
        XYItemModel *firstModel =self.tabControl.ListDataSource[self.firstSelectRow];
        XYItemModel *secondModel = firstModel.dataSource[self.secondSelectRow];
        self.threeListDataSource = secondModel.dataSource;
        return secondModel.dataSource.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TabMenuCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.backgroundColor = [UIColor clearColor];
    XYItemModel *currentModel;
    if (tableView == self.tableViewArr[0]) {
        currentModel = self.tabControl.ListDataSource[indexPath.row];
        
    }else if (tableView == self.tableViewArr[1]) {
        // 根据第一层选中的索引获取包含的第二层数组
        XYItemModel *firstModel =self.tabControl.ListDataSource[self.firstSelectRow];
        currentModel = firstModel.dataSource[indexPath.row];
        
    }else {
        XYItemModel *firstModel =self.tabControl.ListDataSource[self.firstSelectRow];
        XYItemModel *secondModel = firstModel.dataSource[self.secondSelectRow];
        currentModel = secondModel.dataSource[indexPath.row];
    }
    cell.textLabel.text = currentModel.displayText;
    cell.textLabel.textColor = currentModel.seleceted ? [UIColor colorWithRed:(87)/255.0 green:(33)/255.0 blue:(129)/255.0 alpha:1.0] : [UIColor blackColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 如果调用  [tableView reloadData]; 则 tableView.indexPathForSelectedRow.row; 就会清空， 故就此处理。
    if (tableView == self.tableViewArr[0]) {
        // 如果是恢复上次的选中，则不执行一下逻辑。
        if(self.flag){
            self.firstSelectRow = selects[0];
            self.flag = NO;
            return;
        }
        self.firstSelectRow = tableView.indexPathForSelectedRow.row;
        [self resetOldSelectWithDataSource:self.oneListDataSource selectRow:indexPath.row];
        [tableView reloadData];
        
        XYItemModel *selectModel = self.oneListDataSource[indexPath.row];
        if (selectModel.dataSource.count) {
            UITableView *tableView = self.tableViewArr[1];
            [tableView reloadData];
            // 如果是二级列表，选择第一级时，重置第二级的选中。
            [self resetOldSelectWithDataSource:self.twoListDataSource selectRow:0];
            [self adjustTableViewsWithCount:2];
        }else {
            // 表明只有一层数据。。选中第一行则恢复初始的title. 反正显示选中的数据
            [self resetActionTitle:selectModel selectRow:indexPath.row];
            if (self.tabControl.didSelectedMenuResult) {
                self.tabControl.didSelectedMenuResult(indexPath.row, selectModel);
            }
            [self dismiss];
        }
        // 如果选中第一级的不限，重置所有选中
        if (indexPath.row == 0) {
            for (int i = 0; i < 3; i++) {
                selects[i] = -1;
            }
        }
        
    }else if (tableView == self.tableViewArr[1]) {
        if(self.flag) {
            self.flag = NO;
            self.secondSelectRow = selects[1];
            return;
        }
        XYItemModel *selectModel = self.twoListDataSource[indexPath.row];
        // 点击第二层时保存第一层选中的。
        if (!selectModel.dataSource.count) {
            selects[0] = self.firstSelectRow;
            selects[1] = tableView.indexPathForSelectedRow.row;
        }
        self.secondSelectRow = tableView.indexPathForSelectedRow.row;
        [self resetOldSelectWithDataSource:self.twoListDataSource selectRow:indexPath.row];
        [tableView reloadData];
        
        if (selectModel.dataSource.count) {
            UITableView *tableView = self.tableViewArr[2];
            [tableView reloadData];
            // 如果是三级级列表，选择第二级时，重置第三级的选中。
            [self resetOldSelectWithDataSource:self.threeListDataSource selectRow:0];
            [self adjustTableViewsWithCount:3];
        }else {
            if(indexPath.row == 0) {
                // 清除第三级选中的记录
                selects[2] = -1;
                // 如果选中的是0， 则将上一级选中的数据返回
                [self resetActionTitle:self.oneListDataSource[self.firstSelectRow] selectRow:1];
                if (self.tabControl.didSelectedMenuResult) {
                    self.tabControl.didSelectedMenuResult(self.firstSelectRow, self.oneListDataSource[self.firstSelectRow]);
                }
                [self dismiss];
            }else {
                [self resetActionTitle:selectModel selectRow:indexPath.row];
                if (self.tabControl.didSelectedMenuResult) {
                    self.tabControl.didSelectedMenuResult(indexPath.row, selectModel);
                }
                [self dismiss];
            }
        }
        
    }else {
        if(self.flag) {
            self.flag = NO;
            self.lastSelectRow = selects[2];
            return;
        }
        self.lastSelectRow = tableView.indexPathForSelectedRow.row;
        selects[0] = self.firstSelectRow;
        selects[1] = self.secondSelectRow;
        selects[2] = tableView.indexPathForSelectedRow.row;
        
        [self resetOldSelectWithDataSource:self.threeListDataSource selectRow:indexPath.row];
        [tableView reloadData];
        
        XYItemModel *selectModel = self.threeListDataSource[indexPath.row];
        if (indexPath.row == 0 ) {
            // 如果选中的是0， 则将上一级选中的数据返回
            [self resetActionTitle:self.twoListDataSource[self.secondSelectRow] selectRow:1];
            if (self.tabControl.didSelectedMenuResult) {
                self.tabControl.didSelectedMenuResult(self.secondSelectRow, self.twoListDataSource[self.secondSelectRow]);
            }
            
        }else {
            [self resetActionTitle:selectModel selectRow:indexPath.row];
            if (self.tabControl.didSelectedMenuResult) {
                self.tabControl.didSelectedMenuResult(indexPath.row, selectModel);
            }
        }
        [self dismiss];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];
    point.y += self.frame.origin.y;
    CALayer *layer = [self.layer hitTest:point];
    if (layer == self.layer) {
        [self dismiss];
    }
}


/** 懒加载 */
- (NSArray *)tableViewArr {
    
    if (_tableViewArr == nil) {
        
        _tableViewArr = @[[[UITableView alloc] init], [[UITableView alloc] init], [[UITableView alloc] init]];
        __weak typeof(self)weakSelf = self;
        [_tableViewArr enumerateObjectsUsingBlock:^(UITableView *tableView, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TabMenuCell"];
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.frame = CGRectMake(0, 0, 0, 0);
            tableView.showsVerticalScrollIndicator = NO;
            tableView.tableFooterView = [UIView new];
            [weakSelf addSubview:tableView];
            switch (idx) {
                case 0:
                    tableView.backgroundColor = [UIColor whiteColor];
                    break;
                case 1:
                    tableView.backgroundColor = [UIColor colorWithRed:250/ 255.0 green:250/ 255.0 blue:250/ 255.0 alpha:1.0];
                    break;
                case 2:
                    tableView.backgroundColor = [UIColor colorWithRed:245/ 255.0 green:245/ 255.0 blue:245/ 255.0 alpha:1.0];
                    break;
                    
                default:
                    break;
            }
        }];
    }
    return _tableViewArr;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
