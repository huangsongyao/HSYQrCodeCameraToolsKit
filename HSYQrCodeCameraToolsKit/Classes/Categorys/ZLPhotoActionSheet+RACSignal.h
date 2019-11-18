//
//  ZLPhotoActionSheet+RACSignal.h
//  HSYQrCodeCameraToolsKit
//
//  Created by anmin on 2019/11/18.
//

#import <ZLPhotoBrowser/ZLPhotoBrowser.h>
#import <ReactiveObjC/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZLPhotoActionSheet (RACSignal)

/**
 多选相册

 @param maxSelectCount 最大允许选中项数量
 @return RACTuple -> first[NSArray<UIImage> images]、second[NSArray<PHAsset> assets]、third[NSNumber<BOOL> isOriginal]
 */
+ (RACSignal<RACTuple *> *)hsy_multipleSelectedPhoto:(NSInteger)maxSelectCount;

/**
 单选相册

 @return RACTuple -> first[UIImage images]、second[PHAsset assets]、third[NSNumber<BOOL> isOriginal]
 */
+ (RACSignal<RACTuple *> *)hsy_singleSelectedPhoto;

@end

NS_ASSUME_NONNULL_END
