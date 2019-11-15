//
//  HSYQrCodeCameraViewController+RACSignal.h
//  HSYQrCodeCameraTools
//
//  Created by anmin on 2019/11/14.
//

#import "HSYQrCodeCameraViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@interface HSYQrCodeCameraViewController (RACSignal)

//RAC下的Delegate Proxy
@property (nonatomic, strong, readonly) RACDelegateProxy *rac_delegateProxy;

/**
 RAC快速方法，会返回一个带block的RAC冷信号，外部通过处理这个冷信号来决定内部的状态

 @return RACSignal<HSYQrCodeCameraDidOutputMetadataBlock> *
 */
- (RACSignal<HSYQrCodeCameraDidOutputMetadataBlock> *)rac_qrCodeCamera;

@end

NS_ASSUME_NONNULL_END
