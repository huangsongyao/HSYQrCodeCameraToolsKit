//
//  UIViewController+QrCamera.h
//  HSYQrCodeCameraTools
//
//  Created by anmin on 2019/11/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (QrCamera)

/**
 二维码相机扫描的有效区域，有效区域是[0, 1]闭区间，需要根据实际坐标系中的frame转化为真实的有效区域

 @param rect 二维码相机实际有效扫描区域的frame
 @return 二维码相机有效区域的坐标的frame
 */
- (CGRect)hsy_qrCodeScaning:(CGRect)rect;

@end

NS_ASSUME_NONNULL_END
