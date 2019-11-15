//
//  CAAnimation+QrCamera.h
//  HSYQrCodeCameraTools
//
//  Created by anmin on 2019/11/13.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CAAnimation (QrCamera)

/**
 开启一个二维码扫描动画，如果本身已经挂钩了key的一个，则先停止再执行

 @param toValue 动画值
 @param layer 动画执行的layer层
 @param key 动画的key
 */
+ (void)hsy_qrCameraScaningAnimation:(CGFloat)toValue onLayer:(CALayer *)layer forKey:(NSString *)key;

/**
 移除二维码扫描动画

 @param forKey 动画的key
 @param layer 动画执行的layer层
 */
+ (void)hsy_removeQrCameraAnimation:(NSString *)forKey byLayer:(CALayer *)layer;

@end

NS_ASSUME_NONNULL_END
