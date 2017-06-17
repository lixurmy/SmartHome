//
//  SHQRCodeScannerViewController.m
//  SmartHome
//
//  Created by Xu Li on 2017/6/12.
//  Copyright © 2017年 Xu Li. All rights reserved.
//

#import "SHQRCodeScannerViewController.h"
#import "SHQRCodeMaskView.h"
#import <AVFoundation/AVFoundation.h>

@interface SHQRCodeScannerViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureDeviceInput *deviceInput;
@property (nonatomic, strong) AVCaptureMetadataOutput *metaDataOutput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) SHQRCodeMaskView *maskView;
@property (nonatomic, assign) CGRect scanRect;
@property (nonatomic, assign) BOOL hasDetectedQRCode;

@end

@implementation SHQRCodeScannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hasDetectedQRCode = NO;
    if (![self checkAuthStatus]) {
        return;
    }
    CGFloat wSpace = (kScreenWidth - 200)/2;
    // Do any additional setup after loading the view.
    self.scanRect = CGRectMake(wSpace, 100, 200, 200);
    [self.metaDataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    [self.session addInput:self.deviceInput];
    [self.session addOutput:self.metaDataOutput];
    [self.metaDataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code]];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self.previewLayer setFrame:self.view.bounds];
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    [self.view addSubview:self.maskView];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(self.shNavigationBarHeight);
        make.left.right.bottom.equalTo(self.view);
    }];
    [self.session startRunning];
    [[NSNotificationCenter defaultCenter] addObserverForName:AVCaptureInputPortFormatDescriptionDidChangeNotification
                                                      object:nil
                                                       queue:[NSOperationQueue currentQueue]
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                      [self showHint:@"resetInset" duration:1.0];
        self.metaDataOutput.rectOfInterest = [self.previewLayer metadataOutputRectOfInterestForRect:self.scanRect];
    }];
}


- (BOOL)checkAuthStatus {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied) {
        [self showAuthorizationAlert];
        return NO;
    } else {
        return YES;
    }
}

- (void)showAuthorizationAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                   message:@"开启摄像头权限"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *goSettingsAction = [UIAlertAction actionWithTitle:@"去设置"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
        [self openSystemSettings];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
    [alert addAction:goSettingsAction];
    [alert addAction:cancelAction];
    
}

- (BOOL)openSystemSettings {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        return YES;
    } else {
        return NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Lazy Load
- (AVCaptureSession *)session {
    if (!_session) {
        _session = [[AVCaptureSession alloc] init];
    }
    return _session;
}

- (AVCaptureDevice *)device {
    if (!_device) {
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return _device;
}

- (AVCaptureDeviceInput *)deviceInput {
    if (!_deviceInput) {
        _deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    }
    return _deviceInput;
}

- (AVCaptureMetadataOutput *)metaDataOutput {
    if (!_metaDataOutput) {
        _metaDataOutput = [[AVCaptureMetadataOutput alloc] init];
    }
    return _metaDataOutput;
}

- (AVCaptureVideoPreviewLayer *)previewLayer {
    if (!_previewLayer) {
        _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    }
    return _previewLayer;
}

- (SHQRCodeMaskView *)maskView {
    if (!_maskView) {
        _maskView = [[SHQRCodeMaskView alloc] initWithScanRect:self.scanRect];
    }
    return _maskView;
}

#pragma mark - Delegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    AVMetadataMachineReadableCodeObject *metaDataObject = metadataObjects.firstObject;
    if ([metaDataObject.type isEqualToString:AVMetadataObjectTypeQRCode]) {
        self.hasDetectedQRCode = YES;
        @weakify(self);
        if (self.scanHandler) {
            self.scanHandler(self_weak_, metaDataObject.stringValue);
        }
        [self showHint:metaDataObject.stringValue duration:1.0];
    }
}

#pragma mark - VC Relative
- (BOOL)hideNavigationBar {
    return YES;
}

- (BOOL)hasSHNavigationBar {
    return YES;
}

- (NSString *)title {
    return @"QRCode";
}

@end
