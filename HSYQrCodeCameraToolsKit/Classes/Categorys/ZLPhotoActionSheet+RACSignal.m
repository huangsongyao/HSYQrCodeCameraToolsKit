//
//  ZLPhotoActionSheet+RACSignal.m
//  HSYQrCodeCameraToolsKit
//
//  Created by anmin on 2019/11/18.
//

#import "ZLPhotoActionSheet+RACSignal.h"
#import <HSYMethodsToolsKit/RACSignal+Convenients.h>

static ZLPhotoActionSheet *zlPhotoActionSheet = nil;

@implementation ZLPhotoActionSheet (RACSignal)

+ (ZLPhotoActionSheet *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        zlPhotoActionSheet = [ZLPhotoActionSheet new];
        //默认禁止视频和GIF图
        zlPhotoActionSheet.configuration.allowSelectVideo = NO;
        zlPhotoActionSheet.configuration.allowSelectGif = NO;
    });
    return zlPhotoActionSheet;
}

+ (RACSignal<RACTuple *> *)hsy_multipleSelectedPhoto:(NSInteger)maxSelectCount
{
    return [RACSignal hsy_signalSubscriber:^(id<RACSubscriber>  _Nonnull subscriber) {
        ZLPhotoActionSheet *zlPhoto = [ZLPhotoActionSheet sharedInstance];
        zlPhoto.configuration.maxSelectCount = maxSelectCount;
        zlPhoto.selectImageBlock = ^(NSArray<UIImage *> * _Nullable images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
            [RACSignal hsy_performSendSignal:subscriber forObject:RACTuplePack(images, assets, @(isOriginal))];
        };
        zlPhoto.cancleBlock = ^{
            [subscriber sendCompleted];
        };
        [zlPhoto showPhotoLibrary];
    }];
}

+ (RACSignal<RACTuple *> *)hsy_singleSelectedPhoto
{
    return [RACSignal hsy_signalSubscriber:^(id<RACSubscriber>  _Nonnull subscriber) {
        [[[self.class hsy_multipleSelectedPhoto:1] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(RACTuple * _Nullable x) {
            [RACSignal hsy_performSendSignal:subscriber forObject:RACTuplePack([x.first firstObject], [x.second firstObject], x.third)];
        } completed:^{
            [subscriber sendCompleted];
        }];
    }];
}

@end
