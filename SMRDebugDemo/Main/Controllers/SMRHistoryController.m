//
//  SMRHistoryController.m
//  appdebuger
//
//  Created by Tinswin on 2019/8/19.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRHistoryController.h"
#import "SMRHistory.h"
#import "SMRHistoryCell.h"

@interface SMRHistoryController ()<
UITableViewDelegate,
UITableViewDataSource
>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray<SMRHistory *> *dataArray;

@end

@implementation SMRHistoryController

static NSString *historyCell = @"history";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationView.title = @"历史记录";
    [self.view addSubview:self.tableView];
    [self getHistoryData];
    [self.tableView reloadData];
}

- (void)getHistoryData {
    self.dataArray = [[SMRHistory selectOrderByLastUpdateTimeDescWithType:self.type] mutableCopy];
}

#pragma UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SMRHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:historyCell forIndexPath:indexPath];
    cell.history = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectBlock) {
        SMRHistory *history = self.dataArray[indexPath.row];
        self.selectBlock(history.content);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        SMRAlertView *alertView = [SMRAlertView alertViewWithContent:@"确定删除？" buttonTitles:@[@"取消", @"删除"] deepColorType:SMRAlertViewButtonDeepColorTypeSure];
        [alertView setSureButtonTouchedBlock:^(id  _Nonnull maskView) {
            SMRHistory *history = self.dataArray[indexPath.row];
            NSString *where = @"WHERE content=(?) AND type=(?)";
            [SMRHistory deleteWhere:where paramsArray:@[history.content, @(history.type)]];
            [self.dataArray removeObject:history];
            [self.tableView reloadData];
            [maskView hide];
        }];
        [alertView show];
        
    }];
    deleteAction.backgroundColor = [UIColor smr_generalRedColor];
    
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"添加name" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self addNameWithHistory:self.dataArray[indexPath.row]];
    }];
    editAction.backgroundColor = [UIColor smr_generalOrangeColor];
    
    return @[deleteAction, editAction];
}


- (void)addNameWithHistory:(SMRHistory *)history {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"为历史记录加名称" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    //在AlertView中添加一个输入框
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入记录名称";
        textField.text = history.name;
        textField.clearButtonMode = UITextFieldViewModeAlways;
    }];
    
    //添加一个确定按钮 并获取AlertView中的第一个输入框 将其文本赋值给BUTTON的title
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alertController.textFields.firstObject;
        history.name = textField.text;
//        NSString *where = @"WHERE content=:content AND type=:type";
        NSString *where = @"SET name=(?) WHERE content=(?) AND type=(?)";
        [SMRHistory updateSetWhere:where params:@[history.name?:@"", history.content?:@"", @(history.type)]];
        [self getHistoryData];
        [self.tableView reloadData];
    }]];
    //添加一个取消按钮
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    //present出AlertView
    [self presentViewController:alertController animated:true completion:nil];
}

- (NSArray *)getContentsWithKey:(NSString *)key {
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return arr;
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT - self.navigationView.bottom)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.estimatedRowHeight = 50;
        [_tableView registerClass:[SMRHistoryCell class] forCellReuseIdentifier:historyCell];
    }
    return _tableView;
}

- (NSMutableArray<SMRHistory *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

@end
