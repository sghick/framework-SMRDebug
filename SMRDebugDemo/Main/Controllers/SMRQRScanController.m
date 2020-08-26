//
//  SMRQRScanController.m
//  appdebuger
//
//  Created by 丁治文 on 2019/4/18.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRQRScanController.h"
#import "PureLayout.h"
#import "SMRAdapter.h"
#import "LBXScanViewStyle.h"

@interface SMRQRScanController ()

@property (strong, nonatomic) UIButton *codeInputBtn;
@property (strong, nonatomic) UIButton *lightBtn;

@end

@implementation SMRQRScanController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.codeInputBtn];
    [self.view addSubview:self.lightBtn];
    
    [self addSubviewConstraints];
    [self bringNavigationViewToFront];
    
    self.isOpenInterestRect = YES;
}

- (void)addSubviewConstraints {
    [self.lightBtn autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.lightBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:BOTTOM_HEIGHT + [SMRUIAdapter value:81.0]];
    [self.lightBtn autoSetDimensionsToSize:[SMRUIAdapter size:CGSizeMake(70, 70)]];
}

#pragma mark - Camera

- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array {
    if (!array ||  array.count < 1) {
        [self popAlertMsgWithScanResult:nil];
        return;
    }
    
    LBXScanResult *scanResult = array[0];
    
    NSString *strResult = scanResult.strScanned;
    
    self.scanImage = scanResult.imgScanned;
    
    if (!strResult) {
        [self popAlertMsgWithScanResult:nil];
        return;
    }
    
    //震动提醒
    // [LBXScanWrapper systemVibrate];
    //声音提醒
    // [LBXScanWrapper systemSound];
    
    [self showNextVCWithScanResult:scanResult];
}

- (void)popAlertMsgWithScanResult:(NSString *)strResult {
    if ([self.delegate respondsToSelector:@selector(QRScanController:didScanError:)]) {
        [self.delegate QRScanController:self didScanError:strResult];
    }
}

- (void)showNextVCWithScanResult:(LBXScanResult *)strResult {
    if ([self.delegate respondsToSelector:@selector(QRScanController:didScanResult:)]) {
        [self.delegate QRScanController:self didScanResult:strResult.strScanned];
    }
}

#pragma mark - Actions

- (void)lightBtnAction:(UIButton *)sender {
    [self openOrCloseFlash];
}

#pragma mark - Getters

- (UIButton *)lightBtn {
    if (!_lightBtn) {
        _lightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lightBtn addTarget:self action:@selector(lightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_lightBtn setBackgroundImage:[UIImage imageNamed:@"photo_light_btn"] forState:UIControlStateNormal];
    }
    return _lightBtn;
}

@end
