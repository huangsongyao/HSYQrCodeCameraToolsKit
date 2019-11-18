//
//  HSYQrCodeCameraViewController.h
//  HSYQrCodeCameraTools
//
//  Created by anmin on 2019/11/13.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ReactiveObjC.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString *const kHSYQrCodeCameraAnimationForKey;

typedef RACSignal<RACTuple *> *_Nonnull(^HSYQrCodeCameraDidOutputMetadataBlock)(RACTuple *tuple);

@protocol HSYQrCodeCameraViewControllerDelegate <NSObject>

/**
 扫描委托回调，返回一个metadata的block，这个block包含了metadata.stringValue的值，并且需要返回一个RACTuple元组，这个RACTuple元组的first表示立即停止二维码相机的工作，second表示立即执行pop返回上一页，third表示second的执行类型，只有当second.boolValue == YES时才有效[YES -> pop, NO -> dismiss]
 example :
    [[metadata(RACTuplePack(@(YES), @(YES), @(YES))) deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(RACTuple * _Nullable x) {
        NSLog(@"x.metadata => %@", x.first);
        NSLog(@"completed");
    }];
 @param metadata 包含了metadata.stringValue结果的block
 */
- (void)hsy_qrCodeDidOutputMetadata:(HSYQrCodeCameraDidOutputMetadataBlock)metadata;

@end

@interface HSYQrCodeCameraViewController : UIViewController

@property (nonatomic, weak) id<HSYQrCodeCameraViewControllerDelegate>qrDelegate;

#pragma mark - Runing

//开始执行 => 扫描+扫描动画
- (void)hsy_start;
//停止结束 => 扫描+扫描动画
- (void)hsy_stop;
//入参说明：这个RACTuple元组的first表示立即停止二维码相机的工作，second表示立即执行pop返回上一页，third表示second的执行类型，只有当second.boolValue == YES时才有效[YES -> pop, NO -> dismiss]
- (void)hsy_disposeQrCamera:(RACTuple *)tuple;

#pragma mark - Load

//子类重写这个方法，可以返回一个offsets，来规定二维码的有效扫描区域距离顶部的距离，如果存在UINavigationController的UINavigationBar，则这个方法会返回UINavigationBar的高度[已适配刘海屏]
- (CGFloat)hsy_rectOfInterestOffsets;
//子类重写这个方法，可以返回一个CGPoint，这个CGPoint表示二维码的有效扫描区域的origin，默认情况下这个方法会返回CGPointMake(50.0f, 50.0f)
+ (CGPoint)hsy_boxCGPoints;
//子类重写这个方法，可以返回二维码相机的背景图颜色，默认情况下，这个方法会返回HSY_RGBA(51, 51, 51, 0.7)
+ (UIColor *)hsy_boxColor;
//子类重写这个方法，可以返回二维码相机的有效扫描区域的box图标名称，默认情况下这个方法会返回一个默认的box图标
+ (NSString *)hsy_boxBackgroundImageName;
//子类重写这个方法，可以返回二维码相机的有效扫描区域的line图标名称，默认情况下这个方法会返回一个默认的line图标
+ (NSString *)hsy_boxScaninglineImageName;

#pragma mark - Camera Device

//摄像头设备
- (AVCaptureDevice *)hsy_captureDevice;
//输入输出中间桥接上下文
- (AVCaptureSession *)hsy_captureSession;
//输入设备
- (AVCaptureDeviceInput *)hsy_captureDeviceInput;
//输出设备
- (AVCaptureMetadataOutput *)hsy_captureMetadataOutput;
//相机渲染层
- (AVCaptureVideoPreviewLayer *)hsy_captureVideoPreviewLayer;

@end

NS_ASSUME_NONNULL_END
