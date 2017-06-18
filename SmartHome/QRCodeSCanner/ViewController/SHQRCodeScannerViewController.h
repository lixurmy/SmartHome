//
//  SHQRCodeScannerViewController.h
//  SmartHome
//
//  Created by Xu Li on 2017/6/12.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHBaseViewController.h"
@class SHQRCodeScannerViewController;

typedef void(^SHQRCodeScannerComplete)(SHQRCodeScannerViewController* qrCodeScanner, NSString *result);

@interface SHQRCodeScannerViewController : SHBaseViewController

@property (nonatomic, copy) SHQRCodeScannerComplete scanHandler;

@end
