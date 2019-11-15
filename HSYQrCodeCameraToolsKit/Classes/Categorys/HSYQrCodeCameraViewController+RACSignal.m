//
//  HSYQrCodeCameraViewController+RACSignal.m
//  HSYQrCodeCameraTools
//
//  Created by anmin on 2019/11/14.
//

#import "HSYQrCodeCameraViewController+RACSignal.h"
#import <HSYMethodsToolsKit/NSObject+Runtime.h>
#import "NSObject+RACDescription.h"

@implementation HSYQrCodeCameraViewController (RACSignal)

static void RACUseDelegateProxy(HSYQrCodeCameraViewController *self)
{
    if (self.qrDelegate == self.rac_delegateProxy) return;
    self.rac_delegateProxy.rac_proxiedDelegate = self.qrDelegate;
    self.qrDelegate = (id)self.rac_delegateProxy;
}

- (RACDelegateProxy *)rac_delegateProxy
{
    RACDelegateProxy *proxy = objc_getAssociatedObject(self, _cmd);
    if (!proxy) {
        proxy = [[RACDelegateProxy alloc] initWithProtocol:@protocol(HSYQrCodeCameraViewControllerDelegate)];
        objc_setAssociatedObject(self, _cmd, proxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return proxy;
}

- (RACSignal<HSYQrCodeCameraDidOutputMetadataBlock> *)rac_qrCodeCamera
{
    RACSignal *signal = [[[[self.rac_delegateProxy signalForSelector:@selector(hsy_qrCodeDidOutputMetadata:)] map:^id _Nullable(RACTuple * _Nullable value) {
        HSYQrCodeCameraDidOutputMetadataBlock metadataBlock = value.allObjects.firstObject;
        return metadataBlock;
    }] takeUntil:self.rac_willDeallocSignal] setNameWithFormat:@"%@ - rac_qrCodeCamera", RACDescription(self)];
    RACUseDelegateProxy(self);
    return signal;
}

@end
