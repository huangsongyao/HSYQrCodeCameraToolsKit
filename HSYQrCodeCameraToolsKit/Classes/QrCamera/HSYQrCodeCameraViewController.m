//
//  HSYQrCodeCameraViewController.m
//  HSYQrCodeCameraTools
//
//  Created by anmin on 2019/11/13.
//

#import "HSYQrCodeCameraViewController.h"
#import "UIViewController+QrCamera.h"
#import <HSYMethodsToolsKit/UIView+Frame.h>
#import <HSYMacroKit/HSYToolsMacro.h>
#import "UIImage+QrCamera.h"
#import "UIViewController+SystemSources.h"
#import <HSYMethodsToolsKit/UIAlertController+RACSignal.h>
#import <HSYMethodsToolsKit/UIApplication+AppDelegates.h>
#import "CAAnimation+QrCamera.h"
#import <HSYMethodsToolsKit/NSBundle+PrivateFileResource.h>

NSString *const kHSYQrCodeCameraAnimationForKey  = @"HSYQrCodeCameraAnimationForKey";

@interface HSYQrCodeCameraViewController () <AVCaptureMetadataOutputObjectsDelegate>

//输入输出的中间桥梁
@property (nonatomic, strong) AVCaptureSession *qrCameraSession;
//摄像头设备
@property (nonatomic, strong) AVCaptureDevice *qrCameraDevice;
//输入流
@property (nonatomic, strong) AVCaptureDeviceInput *qrCameraInput;
//输出流
@property (nonatomic, strong) AVCaptureMetadataOutput *qrCameraOutput;
//图象渲染层
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *qrCameraPreviewLayer;
//是否创建了二维码相机
@property (nonatomic, assign) BOOL isCreateQRCodeCamera;
//扫描有效区域
@property (nonatomic, assign) CGRect boxCGRect;
//二维码相机的背景图
@property (nonatomic, strong) UIImageView *qrCodeBackgroundImageView;
//二维码相机的扫描线
@property (nonatomic, strong) UIImageView *qrCodeScaninglineImageView;
//二维码相机的有效扫描区域
@property (nonatomic, strong) UIView *qrCodeBoxView;

@end

@implementation HSYQrCodeCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.blackColor;
    //定义好扫描区域
    CGFloat boxSize = self.view.width - (self.class.hsy_boxCGPoints.x * 2.0f);
    self.boxCGRect = (CGRect){self.class.hsy_boxCGPoints, boxSize, boxSize};
    //初始化ui
    [self addQrCameraUI];
    //状态切换的监听
    @weakify(self);
    [[[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidBecomeActiveNotification object:nil] takeUntil:self.rac_willDeallocSignal] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        NSLog(@"xxxx=>%@, self=>%@", x, self);
        [self hsy_start];
    }];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.haveAuthoritys) {
        [self hsy_startRunning];
    } else {
        [[[UIAlertController hsy_showAlertController:self title:@"您尚未授权摄像头的使用权限" message:@"由于您当前尚未授权您的设备的摄像头使用权限，需要您在系统的 “设置-隐私-相机” 中授权此应用访问您设备的摄像头权限" alertActionTitles:@[@"取消", @"去授权"]] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(UIAlertAction * _Nullable x) {
            if (x.hsy_actionIndex.integerValue) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hsy_startRunningAnimation];
}

#pragma mark - CameraUI

- (void)addQrCameraUI
{
    [self.view addSubview:self.qrCodeBackgroundImageView];
}

#pragma mark - Operation

- (void)hsy_start
{
    [self hsy_startRunning];
    [self hsy_startRunningAnimation];
}

- (void)hsy_stop
{
    [self hsy_stopRunning];
    [self hsy_stopRunningAnimation];
}

#pragma mark - Lazy

- (BOOL)haveAuthoritys
{
    return UIViewController.hsy_haveAuthoritys;
}

- (AVCaptureSession *)qrCameraSession
{
    if (!_qrCameraSession) {
        if (self.haveAuthoritys) {
            _qrCameraSession = [[AVCaptureSession alloc] init];
            [_qrCameraSession setSessionPreset:AVCaptureSessionPresetHigh];          //高质量采集率
            [_qrCameraSession addInput:self.qrCameraInput];
            [_qrCameraSession addOutput:self.qrCameraOutput];
            //完成输入流和输出流的对接后,开始设置输出流的支持类型，扫码支持的编码格式(如下设置条形码和二维码兼容)
            self.qrCameraOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
            //输入流和输出流对接后，设置对应的视图渲染层，用以捕获摄像头的数据信息
            [self.view.layer insertSublayer:self.qrCameraPreviewLayer atIndex:0];
        }
    }
    return _qrCameraSession;
}

- (AVCaptureDevice *)qrCameraDevice
{
    if (!_qrCameraDevice) {
        if (self.haveAuthoritys) {
            _qrCameraDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        }
    }
    return _qrCameraDevice;
}

- (AVCaptureDeviceInput *)qrCameraInput
{
    if (!_qrCameraInput) {
        if (self.haveAuthoritys) {
            NSError *error = nil;
            _qrCameraInput = [AVCaptureDeviceInput deviceInputWithDevice:self.qrCameraDevice error:&error];
            if (error) {
                NSLog(@"QRCode Camera Error!------AVCaptureDeviceInput Error:%@", error);
                return nil;
            }
        }
    }
    return _qrCameraInput;
}

- (AVCaptureMetadataOutput *)qrCameraOutput
{
    if (!_qrCameraOutput) {
        if (self.haveAuthoritys) {
            _qrCameraOutput = [[AVCaptureMetadataOutput alloc] init];
            //扫描范围
            CGRect rectOfInterest = [self hsy_qrCodeScaning:(CGRect){self.class.hsy_boxCGPoints.x, (self.class.hsy_boxCGPoints.y + self.hsy_rectOfInterestOffsets), self.boxCGRect.size}];
            _qrCameraOutput.rectOfInterest = rectOfInterest;
            //设置代理 在主线程里刷新
            [_qrCameraOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        }
    }
    return _qrCameraOutput;
}

- (AVCaptureVideoPreviewLayer *)qrCameraPreviewLayer
{
    if (!_qrCameraPreviewLayer) {
        if (self.haveAuthoritys) {
            _qrCameraPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.qrCameraSession];
            _qrCameraPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            _qrCameraPreviewLayer.frame = self.view.layer.bounds;
        }
    }
    return _qrCameraPreviewLayer;
}

- (UIImageView *)qrCodeBackgroundImageView
{
    if (!_qrCodeBackgroundImageView) {
        UIImage *image = [UIImage hsy_imageWithQRCode:CGRectMake(0.0f, 0.0f, self.view.width, (self.view.height - self.hsy_rectOfInterestOffsets)) cropRect:self.boxCGRect backgroundColor:self.class.hsy_boxColor];
        _qrCodeBackgroundImageView = [[UIImageView alloc] initWithImage:image highlightedImage:image];
        _qrCodeBackgroundImageView.frame = CGRectMake(0.0f, self.hsy_rectOfInterestOffsets, self.view.width, (self.view.height - self.hsy_rectOfInterestOffsets));
        [_qrCodeBackgroundImageView addSubview:self.qrCodeBoxView];
        [_qrCodeBackgroundImageView addSubview:self.qrCodeScaninglineImageView];
    }
    return _qrCodeBackgroundImageView;
}

- (UIImageView *)qrCodeScaninglineImageView
{
    if (!_qrCodeScaninglineImageView) {
        UIImage *image = [NSBundle hsy_imageForBundle:self.class.hsy_boxScaninglineImageName];
        _qrCodeScaninglineImageView = [[UIImageView alloc] initWithImage:image highlightedImage:image];
        _qrCodeScaninglineImageView.frame = (CGRect){self.boxCGRect.origin, CGRectGetWidth(self.boxCGRect), 2.0f};
    }
    return _qrCodeScaninglineImageView;
}

- (UIView *)qrCodeBoxView
{
    if (!_qrCodeBoxView) {
        _qrCodeBoxView = [[UIView alloc] initWithFrame:self.boxCGRect];
        UIImage *image = [NSBundle hsy_imageForBundle:self.class.hsy_boxBackgroundImageName];
        UIImageView *boxBackgroundImageView = [[UIImageView alloc] initWithImage:image highlightedImage:image];
        boxBackgroundImageView.frame = _qrCodeBoxView.bounds;
        [_qrCodeBoxView addSubview:boxBackgroundImageView];
    }
    return _qrCodeBoxView;
}

#pragma mark - StartRunning && StopRunning

- (void)hsy_startRunning
{
    if (!self.qrCameraSession.isRunning) {
        [self.qrCameraSession startRunning];
    }
}

- (void)hsy_stopRunning
{
    if (self.qrCameraSession.isRunning) {
        [self.qrCameraSession stopRunning];
    }
}

#pragma mark - StartAnimation && StopAnimation

- (void)hsy_startRunningAnimation
{
    [CAAnimation hsy_qrCameraScaningAnimation:(CGRectGetHeight(self.boxCGRect) - self.qrCodeScaninglineImageView.height) onLayer:self.qrCodeScaninglineImageView.layer forKey:kHSYQrCodeCameraAnimationForKey];
}

- (void)hsy_stopRunningAnimation
{
    [CAAnimation hsy_removeQrCameraAnimation:kHSYQrCodeCameraAnimationForKey byLayer:self.qrCodeScaninglineImageView.layer];
}

#pragma mark - Dealloc

- (void)dealloc
{
    [self hsy_stop];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(nonnull AVCaptureConnection *)connection
{
    if (metadataObjects.count > 0) {
        @weakify(self);
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects firstObject];
        NSLog(@"QR Code Camera Metadata => %@", metadataObject.stringValue);
        if (self.qrDelegate && [self.qrDelegate respondsToSelector:@selector(hsy_qrCodeDidOutputMetadata:)]) {
            [self.qrDelegate hsy_qrCodeDidOutputMetadata:^RACSignal<RACTuple *> * _Nonnull(RACTuple * _Nonnull tuple) {
                @strongify(self);
                [self hsy_disposeQrCamera:tuple];
                return [RACSignal hsy_sendTupleSignal:RACTuplePack(metadataObject.stringValue, self)];
            }];
        }
    }
}

- (void)hsy_disposeQrCamera:(RACTuple *)tuple
{
    if ([tuple.first boolValue]) {
        [self hsy_stop];
        NSLog(@"QR Code Camera => Stop Work");
    }
    if ([tuple.second boolValue]) {
        BOOL backType = [tuple.third boolValue];
        if (backType) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        NSLog(@"QR Code Camera => Back Last");
    }
}

#pragma mark - Load

- (CGFloat)hsy_rectOfInterestOffsets
{
    if (!self.navigationController.navigationBar.hidden) {
        return [UIApplication hsy_navigationBarHeights];
    }
    return 0.0f;
}

+ (CGPoint)hsy_boxCGPoints
{
    return CGPointMake(50.0f, 50.0f);
}

+ (UIColor *)hsy_boxColor
{
    return HSY_RGBA(51, 51, 51, 0.7);
}

+ (NSString *)hsy_boxBackgroundImageName
{
    return @"img_scanning_box";
}

+ (NSString *)hsy_boxScaninglineImageName
{
    return @"img_scanning_line";
}

#pragma mark - Getter Device

- (AVCaptureDevice *)hsy_captureDevice
{
    return self.qrCameraDevice;
}

- (AVCaptureSession *)hsy_captureSession
{
    return self.qrCameraSession;
}

- (AVCaptureDeviceInput *)hsy_captureDeviceInput
{
    return self.qrCameraInput;
}

- (AVCaptureMetadataOutput *)hsy_captureMetadataOutput
{
    return self.qrCameraOutput;
}

- (AVCaptureVideoPreviewLayer *)hsy_captureVideoPreviewLayer
{
    return self.qrCameraPreviewLayer;
}


@end
