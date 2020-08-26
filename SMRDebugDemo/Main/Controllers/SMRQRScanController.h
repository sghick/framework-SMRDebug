//
//  SMRQRScanController.h
//  appdebuger
//
//  Created by 丁治文 on 2019/4/18.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRLBXScanController.h"

NS_ASSUME_NONNULL_BEGIN

@class SMRQRScanController;
@protocol SMRQRScanControllerDelegate <SMRLBXScanViewControllerDelegate>

- (void)QRScanController:(SMRQRScanController *)controller didScanError:(NSString *)error;
- (void)QRScanController:(SMRQRScanController *)controller didScanResult:(NSString *)result;

@end

@interface SMRQRScanController : SMRLBXScanController

@property (weak  , nonatomic) id<SMRQRScanControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
