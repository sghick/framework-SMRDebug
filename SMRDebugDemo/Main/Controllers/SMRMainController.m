//
//  SMRMainController.m
//  appdebuger
//
//  Created by 丁治文 on 2019/4/17.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRMainController.h"
#import "SMRDebuger.h"
#import "SMRQRScanController.h"
#import "SMRHistoryController.h"
#import "SMRHistory.h"

@interface SMRMainController ()<
UITextFieldDelegate,
SMRQRScanControllerDelegate>

@property (strong, nonatomic) UIButton *changeVersionBtn;
@property (strong, nonatomic) UIButton *showDebugBarBtn;
@property (strong, nonatomic) UITextView *statusLabel;
@property (strong, nonatomic) UITextField *identifierField;
@property (strong, nonatomic) UIButton *identifierHisBtn;
@property (strong, nonatomic) UITextField *schemeField;
@property (strong, nonatomic) UIButton *schemeHisBtn;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UITextField *webURLField;
@property (strong, nonatomic) UIButton *webURLHisBtn;

@end

@implementation SMRMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    SMRLog0(@"加载完成", @"加载");
    SMRLogBegin();
    SMRLog0(@"加载完成", @"加载1");
    SMRLog0(@"加载完成", @"加载2");
    SMRLog0(@"加载完成", @"加载3");
    SMRLog0(@"加载完成", @"加载4");
    SMRLog0(@"加载完成", @"加载5");
    SMRLog0(@"加载完成", @"加载6");
    SMRLog0(@"加载完成", @"加载7");
    SMRLog0(@"加载完成", @"加载8");
    SMRLog0(@"加载完成", @"加载9");
    SMRLog0(@"加载完成", @"加载0");
    SMRLog0(@"加载完成", @"加载01");
    SMRLog0(@"加载完成", @"加载02");
    SMRLog0(@"加载完成", @"加载03");
    SMRLog0(@"加载完成", @"加载04");
    SMRLog0(@"加载完成", @"加载05");
    SMRLog0(@"加载完成", @"加载06");
    SMRLog0(@"加载完成", @"加载04");
    SMRLog0(@"加载完成", @"加载04");
    
    self.navigationView.backBtnHidden = YES;
    self.navigationView.leftView = self.changeVersionBtn;
    self.navigationView.rightView = self.showDebugBarBtn;
    self.showDebugBarBtn.selected = ([SMRDebug deubgMode] != SMRDebugModeNone);
    [self changeTitle];
    
    [self.view addSubview:self.statusLabel];
    [self.view addSubview:self.identifierField];
    [self.view addSubview:self.identifierHisBtn];
    [self.view addSubview:self.schemeField];
    [self.view addSubview:self.schemeHisBtn];
    [self.view addSubview:self.timeLabel];
    [self.view addSubview:self.webURLField];
    [self.view addSubview:self.webURLHisBtn];
    
    NSArray<UIButton *> *array = @[[self buttonWithTitle:@"调试器\n(On)" action:@selector(onBtnClick)],
                                   [self buttonWithTitle:@"调试器\n(OffAll)" action:@selector(offAllBtnClick)],
                                   [self buttonWithTitle:@"调试器\n(Off)" action:@selector(offBtnClick)],
                                   [self buttonWithTitle:@"扫码" action:@selector(QRCodeBtnClick)],
                                   [self buttonWithTitle:@"Encode\n(URL)" action:@selector(encodeURLBtnClick)],
                                   [self buttonWithTitle:@"Decode\n(URL)" action:@selector(decodeURLBtnClick)],
                                   [self buttonWithTitle:@"Encode\n(Query)" action:@selector(encodeURLQueryBtnClick)],
                                   [self buttonWithTitle:@"打开\n(URL)" action:@selector(openURLBtnClick)],
                                   [self buttonWithTitle:@"调试器\n令牌" action:@selector(keyBtnClick)],];
    
    CGFloat btnWidth = 60.0;
    self.statusLabel.frame = CGRectMake(20, self.navigationView.bottom + 10, SCREEN_WIDTH - 2*20, 80);
    self.identifierField.frame = CGRectMake(20, self.statusLabel.bottom + 10, SCREEN_WIDTH - 2*20 - btnWidth, 40);
    self.identifierHisBtn.frame = CGRectMake(self.identifierField.right, self.statusLabel.bottom + 10, btnWidth, 40);
    self.schemeField.frame = CGRectMake(20, self.identifierField.bottom + 10, SCREEN_WIDTH - 3*20 - 120 - btnWidth, 40);
    self.timeLabel.frame = CGRectMake(self.schemeField.right + 10, self.identifierField.bottom + 10, 120, 40);
    self.schemeHisBtn.frame = CGRectMake(self.identifierField.right, self.identifierField.bottom + 10, btnWidth, 40);
    self.webURLField.frame = CGRectMake(20, self.schemeField.bottom + 10, SCREEN_WIDTH - 2*20 - btnWidth, 40);
    self.webURLHisBtn.frame = CGRectMake(self.webURLField.right, self.schemeField.bottom + 10, btnWidth, 40);
    
    CGRect showBounds = CGRectMake(20, self.webURLField.bottom + 10, SCREEN_WIDTH - 2*20, SCREEN_HEIGHT - (self.identifierField.bottom + 10));
    CGSize cellSize = CGSizeMake(80, 80);
    SMRMatrixCalculator *calculator = [SMRMatrixCalculator calculatorForVerticalWithBounds:showBounds
                                                                              columnsCount:4
                                                                                spaceOfRow:10
                                                                                  cellSize:cellSize];
    
    for (int i = 0; i < array.count; i++) {
        UIButton *view = array[i];
        view.frame = [calculator cellFrameWithIndex:i];
        [view setTitleColor:[UIColor smr_whiteColor] forState:UIControlStateNormal];
        view.backgroundColor = [UIColor smr_darkGrayColor];
        view.layer.cornerRadius = 3;
        view.layer.borderColor = [UIColor smr_darkGrayColor].CGColor;
        view.layer.borderWidth = 1;
        
        [self.view addSubview:view];
    }
    
    __weak typeof(self) weakSelf = self;
    if (@available(iOS 10.0, *)) {
        [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [weakSelf updateTimer];
        }];
    } else {
        // Fallback on earlier versions
        [NSTimer scheduledTimerWithTimeInterval:1 target:weakSelf selector:@selector(updateTimer) userInfo:nil repeats:YES];
    }
}

#pragma mark - Utils

- (void)updateTimer {
    self.timeLabel.text = [SMRUtils convertToStringFromDate:[NSDate date] format:@"yyyy-MM-dd\nHH:mm:ss"];
}

- (NSArray<NSError *> *)validateEmptyWithTextFields:(NSArray<UITextField *> *)textFields {
    NSMutableArray *arr = [NSMutableArray array];
    for (UITextField *txt in textFields) {
        if (!txt.text.length) {
            NSError *error = [NSError smr_errorWithDomain:@"com.SMR.debug.validate.error.domain"
                                                     code:100
                                                   detail:txt.placeholder
                                                  message:nil
                                                 userInfo:@{@"object":txt}];
            [arr addObject:error];
            break;
        }
    }
    return [arr copy];
}

- (NSString *)filterDebugScheme:(NSString *)scheme {
    NSMutableString *str = [scheme mutableCopy];
    if (![scheme containsString:@"-debug"]) {
        [str appendString:@"-debug"];
    }
    return [str copy];
}

- (UIButton *)buttonWithTitle:(NSString *)title action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.numberOfLines = 0;
    return btn;
}

- (void)saveToUDWithContent:(NSString *)content key:(SMRHistoryType)type {
    NSString *where = @"WHERE content=(?) AND type=(?)";
    NSArray<SMRHistory *> *contentArr = [SMRHistory selectWhere:where paramsArray:@[content, @(type)]];
    SMRHistory *history = contentArr.firstObject;
    if (!history) {
        history = [[SMRHistory alloc] init];
    }
    history.content = content;
    history.type = type;
    history.last_update_time = [[NSDate date] timeIntervalSince1970];
    history.use_count++;
    [SMRHistory insertOrReplace:@[history] primaryKeys:@[@"content", @"type"]];
}

- (void)saveToUDWithScheme:(NSString *)scheme uk:(NSString *)uk webURL:(NSString *)webURL {
    [self saveToUDWithContent:uk key:SMRHistoryTypeIdentifier];
    [self saveToUDWithContent:scheme key:SMRHistoryTypeScheme];
    [self saveToUDWithContent:webURL key:SMRHistoryTypeWebURL];
}

- (NSArray *)getContentsWithKey:(NSString *)key {
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return arr;
}

#pragma mark - History

- (NSString *)historyForScheme {
    return [self contentHistoryForType:SMRHistoryTypeScheme];
}

- (NSString *)historyForIdentifier {
    return [self contentHistoryForType:SMRHistoryTypeIdentifier];
}

- (NSString *)historyForWebURL {
    return [self contentHistoryForType:SMRHistoryTypeWebURL];
}

- (NSString *)contentHistoryForType:(SMRHistoryType)type {
    return [SMRHistory selectOrderByLastUpdateTimeDescWithType:type].firstObject.content;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - SMRQRScanControllerDelegate

- (void)QRScanController:(SMRQRScanController *)controller didScanError:(NSString *)error {
    [controller popOrDismissViewController];
    [SMRUtils toast:@"扫描失败"];
}

- (void)QRScanController:(SMRQRScanController *)controller didScanResult:(NSString *)result {
    [controller popOrDismissViewController];
    self.statusLabel.text = result;
    self.webURLField.text = result;
    NSString *tag = @"input::";
    if ([result hasPrefix:tag]) {
        NSString *nr = [result substringFromIndex:tag.length];
        NSArray<NSString *> *inputs = [nr componentsSeparatedByString:@"::"];
        if (inputs.count >= 1) {
            self.identifierField.text = inputs[0];
        }
        if (inputs.count >= 2) {
            self.schemeField.text = inputs[1];
        }
        if (inputs.count >= 3) {
            self.webURLField.text = inputs[2];
        }
    }
}

#pragma mark - Actions

- (void)historyBtnClick:(UIButton *)historyButton {
    
    SMRHistoryType type;
    void(^selectHistoryBlock)(NSString *history);
    
    if (historyButton == self.identifierHisBtn) {
        type = SMRHistoryTypeIdentifier;
        selectHistoryBlock = ^(NSString *history) {
            self.identifierField.text = history;
        };
    } else if (historyButton == self.schemeHisBtn) {
        type = SMRHistoryTypeScheme;
        selectHistoryBlock = ^(NSString *history) {
            self.schemeField.text = history;
        };
    } else if (historyButton == self.webURLHisBtn) {
        type = SMRHistoryTypeWebURL;
        selectHistoryBlock = ^(NSString *history) {
            self.webURLField.text = history;
        };
    } else {
        [SMRUtils toast:@"未添加此类型"];
        return;
    }
    
    SMRHistoryController *historyVC = [[SMRHistoryController alloc] init];
    historyVC.type = type;
    historyVC.selectBlock = selectHistoryBlock;
    [self.navigationController pushViewController:historyVC animated:YES];
}

- (void)keyBtnClick {
    [self.view endEditing:YES];
    NSArray<NSError *> *errors = [self validateEmptyWithTextFields:@[self.identifierField, self.schemeField]];
    if (errors.count) {
        UITextField *txt = errors.firstObject.userInfo[@"object"];
        [txt becomeFirstResponder];
        [SMRUtils toast:errors.firstObject.smr_detail];
        return;
    }
    
    NSString *scheme = [self filterDebugScheme:self.schemeField.text];
    NSString *uk = self.identifierField.text;
    NSString *ck = [self createCheckCodeWithKey:uk date:[NSDate date]];
    NSString *url = [NSString stringWithFormat:@"%@://debug?uk=%@&ck=%@&status=%@", scheme, uk, ck, @(1)];
    self.statusLabel.text = url;
    [self saveToUDWithScheme:self.schemeField.text uk:self.identifierField.text webURL:self.webURLField.text];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = url;
    [SMRUtils toast:@"复制成功"];
}

- (void)onBtnClick {
    [self.view endEditing:YES];
    NSArray<NSError *> *errors = [self validateEmptyWithTextFields:@[self.identifierField, self.schemeField]];
    if (errors.count) {
        UITextField *txt = errors.firstObject.userInfo[@"object"];
        [txt becomeFirstResponder];
        [SMRUtils toast:errors.firstObject.smr_detail];
        return;
    }
    
    NSString *scheme = [self filterDebugScheme:self.schemeField.text];
    NSString *uk = self.identifierField.text;
    NSString *ck = [self createCheckCodeWithKey:uk date:[NSDate date]];
    
    NSString *url = [NSString stringWithFormat:@"%@://debug?uk=%@&ck=%@&status=%@", scheme, uk, ck, @(1)];
    BOOL open = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    if (!open) {
        [SMRUtils toast:@"无法打开对应的app"];
    }
    self.statusLabel.text = url;
    [self saveToUDWithScheme:self.schemeField.text uk:self.identifierField.text webURL:self.webURLField.text];
}

- (void)offAllBtnClick {
    [self.view endEditing:YES];
    NSArray<NSError *> *errors = [self validateEmptyWithTextFields:@[self.identifierField, self.schemeField]];
    if (errors.count) {
        UITextField *txt = errors.firstObject.userInfo[@"object"];
        [txt becomeFirstResponder];
        [SMRUtils toast:errors.firstObject.smr_detail];
        return;
    }
    
    NSString *scheme = [self filterDebugScheme:self.schemeField.text];
    NSString *uk = self.identifierField.text;
    NSString *ck = [self createCheckCodeWithKey:uk date:[NSDate date]];
    NSString *url = [NSString stringWithFormat:@"%@://debug?uk=%@&ck=%@&status=%@", scheme, uk, ck, @(0)];
    BOOL open = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    if (!open) {
        [SMRUtils toast:@"无法打开对应的app"];
    }
    self.statusLabel.text = url;
    [self saveToUDWithScheme:self.schemeField.text uk:self.identifierField.text webURL:self.webURLField.text];
}

- (void)offBtnClick {
    [self.view endEditing:YES];
    NSArray<NSError *> *errors = [self validateEmptyWithTextFields:@[self.identifierField, self.schemeField]];
    if (errors.count) {
        UITextField *txt = errors.firstObject.userInfo[@"object"];
        [txt becomeFirstResponder];
        [SMRUtils toast:errors.firstObject.smr_detail];
        return;
    }
    
    NSString *scheme = [self filterDebugScheme:self.schemeField.text];
    NSString *uk = self.identifierField.text;
    NSString *ck = [self createCheckCodeWithKey:uk date:[NSDate date]];
    NSString *url = [NSString stringWithFormat:@"%@://debug?uk=%@&ck=%@&status=%@", scheme, uk, ck, @(2)];
    BOOL open = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    if (!open) {
        [SMRUtils toast:@"无法打开对应的app"];
    }
    self.statusLabel.text = url;
    [self saveToUDWithScheme:self.schemeField.text uk:self.identifierField.text webURL:self.webURLField.text];
}

- (void)QRCodeBtnClick {
    SMRQRScanController *qrScan = [[SMRQRScanController alloc] init];
    qrScan.delegate = self;
    [SMRNavigator pushOrPresentToViewController:qrScan animated:YES];
}

- (void)encodeURLBtnClick {
    [self.view endEditing:YES];
    NSArray<NSError *> *errors = [self validateEmptyWithTextFields:@[self.webURLField]];
    if (errors.count) {
        UITextField *txt = errors.firstObject.userInfo[@"object"];
        [txt becomeFirstResponder];
        [SMRUtils toast:errors.firstObject.smr_detail];
        return;
    }
    
    NSString *url = [NSURL smr_encodeURLStringWithString:self.webURLField.text];
    self.statusLabel.text = url;
    self.webURLField.text = url;
}

- (void)decodeURLBtnClick {
    [self.view endEditing:YES];
    NSArray<NSError *> *errors = [self validateEmptyWithTextFields:@[self.webURLField]];
    if (errors.count) {
        UITextField *txt = errors.firstObject.userInfo[@"object"];
        [txt becomeFirstResponder];
        [SMRUtils toast:errors.firstObject.smr_detail];
        return;
    }
    
    NSString *url = [NSURL smr_decodeURLStringWithString:self.webURLField.text];
    self.statusLabel.text = url;
    self.webURLField.text = url;
}

- (void)encodeURLQueryBtnClick {
    [self.view endEditing:YES];
    NSArray<NSError *> *errors = [self validateEmptyWithTextFields:@[self.webURLField]];
    if (errors.count) {
        UITextField *txt = errors.firstObject.userInfo[@"object"];
        [txt becomeFirstResponder];
        [SMRUtils toast:errors.firstObject.smr_detail];
        return;
    }
    
    NSString *url = [NSURL smr_encodeURLQueryStringWithString:self.webURLField.text];
    self.statusLabel.text = url;
    self.webURLField.text = url;
}

- (void)openURLBtnClick {
    [self.view endEditing:YES];
    NSArray<NSError *> *errors = [self validateEmptyWithTextFields:@[self.webURLField]];
    if (errors.count) {
        UITextField *txt = errors.firstObject.userInfo[@"object"];
        [txt becomeFirstResponder];
        [SMRUtils toast:errors.firstObject.smr_detail];
        return;
    }
    
    NSString *scheme = self.schemeField.text;
    NSString *urlStr = self.webURLField.text;
    NSString *url = urlStr;
    // 如果设置了scheme,则使用scheme为协议
    if (scheme.length) {
        NSURL *iURL = [NSURL URLWithString:urlStr];
        if (iURL.scheme.length) {
            // 如果是web,并会自动编码一次
            url = [NSString stringWithFormat:@"%@://web?url=%@", scheme, [NSURL smr_encodeURLStringWithString:urlStr]];
        } else {
            // 非web,直接当成host和参数query部分进行使用
            url = [NSString stringWithFormat:@"%@://%@", scheme, urlStr];
        }
    } else {
        url = urlStr;
    }

    BOOL open = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    if (!open) {
        [SMRUtils toast:@"无法打开对应的app"];
    }
    self.statusLabel.text = url;
    [self saveToUDWithScheme:self.schemeField.text uk:self.identifierField.text webURL:self.webURLField.text];
}

- (void)changeVersion:(UIButton *)changeVersionBtn {
    BOOL isOldVersion = [[NSUserDefaults standardUserDefaults] boolForKey:@"oldVersion"];
    [[NSUserDefaults standardUserDefaults] setBool:!(isOldVersion) forKey:@"oldVersion"];
    [self changeTitle];
}

- (void)changeTitle {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"oldVersion"]) {
        [self.changeVersionBtn setTitle:@"切换新版" forState:UIControlStateNormal];
        self.navigationView.title = @"调试器(旧版本)";
    } else {
        [self.changeVersionBtn  setTitle:@"切换旧版" forState:UIControlStateNormal];
        self.navigationView.title = @"调试器(新版本)";
    }
}

- (void)showDebugBarBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    [SMRDebug setDebug:sender.selected?SMRDebugModeAll:SMRDebugModeNone];
}

- (NSString *)createCheckCodeWithKey:(NSString *)key date:(NSDate *)date {
    if (!([[NSUserDefaults standardUserDefaults] boolForKey:@"oldVersion"])) {
        return [SMRDebug createCheckCodeWithKey:key date:date];
    } else {
        return [SMRDebug old_createCheckCodeWithKey:key date:date];
    }
}

#pragma mark - Getters

- (UIButton *)changeVersionBtn {
    if (!_changeVersionBtn) {
        _changeVersionBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
        _changeVersionBtn.titleLabel.font = [UIFont smr_systemFontOfSize:13];
        [_changeVersionBtn setTitleColor:[UIColor smr_generalBlackColor] forState:UIControlStateNormal];
        [_changeVersionBtn addTarget:self action:@selector(changeVersion:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeVersionBtn;
}

- (UIButton *)showDebugBarBtn {
    if (!_showDebugBarBtn) {
        _showDebugBarBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
        _showDebugBarBtn.titleLabel.font = [UIFont smr_systemFontOfSize:13];
        [_showDebugBarBtn setTitleColor:[UIColor smr_generalBlackColor] forState:UIControlStateNormal];
        [_showDebugBarBtn setTitle:@"ShowBar" forState:UIControlStateNormal];
        [_showDebugBarBtn setTitle:@"HideBar" forState:UIControlStateSelected];
        [_showDebugBarBtn addTarget:self action:@selector(showDebugBarBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showDebugBarBtn;
}

- (UITextView *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UITextView alloc] init];
        _statusLabel.font = [UIFont systemFontOfSize:12];
        _statusLabel.textColor = [UIColor smr_darkGrayColor];
        _statusLabel.backgroundColor = [UIColor smr_backgroundGrayColor];
        _statusLabel.editable = NO;
    }
    return _statusLabel;
}

- (UITextField *)schemeField {
    if (!_schemeField) {
        _schemeField = [[UITextField alloc] init];
        _schemeField.font = [UIFont systemFontOfSize:15];
        _schemeField.placeholder = @"请输入scheme";
        _schemeField.textColor = [UIColor smr_darkGrayColor];
        _schemeField.backgroundColor = [UIColor smr_backgroundGrayColor];
        _schemeField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        _schemeField.leftViewMode = UITextFieldViewModeAlways;
        _schemeField.clearButtonMode = UITextFieldViewModeAlways;
        _schemeField.delegate = self;
        _schemeField.text = [self historyForScheme];
    }
    return _schemeField;
}

- (UIButton *)schemeHisBtn {
    if (!_schemeHisBtn) {
        _schemeHisBtn = [self buttonWithTitle:@"历史" action:@selector(historyBtnClick:)];
        _schemeHisBtn.backgroundColor = [UIColor smr_darkGrayColor];
        [_schemeHisBtn setTitleColor:[UIColor smr_whiteColor] forState:UIControlStateNormal];
    }
    return _schemeHisBtn;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:15];
        _timeLabel.textColor = [UIColor redColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.numberOfLines = 2;
    }
    return _timeLabel;
}

- (UITextField *)identifierField {
    if (!_identifierField) {
        _identifierField = [[UITextField alloc] init];
        _identifierField.font = [UIFont systemFontOfSize:15];
        _identifierField.placeholder = @"请输入对应app的识别码(仅与调试器功能有关)";
        _identifierField.textColor = [UIColor smr_darkGrayColor];
        _identifierField.backgroundColor = [UIColor smr_backgroundGrayColor];
        _identifierField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        _identifierField.leftViewMode = UITextFieldViewModeAlways;
        _identifierField.clearButtonMode = UITextFieldViewModeAlways;
        _identifierField.delegate = self;
        _identifierField.text = [self historyForIdentifier];
    }
    return _identifierField;
}

- (UIButton *)identifierHisBtn {
    if (!_identifierHisBtn) {
        _identifierHisBtn = [self buttonWithTitle:@"历史" action:@selector(historyBtnClick:)];
        _identifierHisBtn.backgroundColor = [UIColor smr_darkGrayColor];
        [_identifierHisBtn setTitleColor:[UIColor smr_whiteColor] forState:UIControlStateNormal];
    }
    return _identifierHisBtn;
}

- (UITextField *)webURLField {
    if (!_webURLField) {
        _webURLField = [[UITextField alloc] init];
        _webURLField.font = [UIFont systemFontOfSize:15];
        _webURLField.placeholder = @"请输入对应URL";
        _webURLField.textColor = [UIColor smr_darkGrayColor];
        _webURLField.backgroundColor = [UIColor smr_backgroundGrayColor];
        _webURLField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        _webURLField.leftViewMode = UITextFieldViewModeAlways;
        _webURLField.clearButtonMode = UITextFieldViewModeAlways;
        _webURLField.delegate = self;
        _webURLField.text = [self historyForWebURL];
    }
    return _webURLField;
}

- (UIButton *)webURLHisBtn {
    if (!_webURLHisBtn) {
        _webURLHisBtn = [self buttonWithTitle:@"历史" action:@selector(historyBtnClick:)];
        _webURLHisBtn.backgroundColor = [UIColor smr_darkGrayColor];
        [_webURLHisBtn setTitleColor:[UIColor smr_whiteColor] forState:UIControlStateNormal];
    }
    return _webURLHisBtn;
}

@end
