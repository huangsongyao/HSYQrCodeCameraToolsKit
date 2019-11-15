//
//  UIViewController+SystemSources.h
//  HSYQrCodeCameraTools
//
//  Created by anmin on 2019/11/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (SystemSources)

/**
 返回UIViewController.hsy_haveCameraAuthoritys && UIViewController.hsy_haveOpenCameraAuthoritys的状态

 @return 摄像头访问权限
 */
+ (BOOL)hsy_haveAuthoritys;

/**
 是否有访问摄像头的权限

 @return 访问摄像头的权限状态
 */
+ (BOOL)hsy_haveCameraAuthoritys;

/**
 是否在info文件中添加了对访问摄像头权限的提示

 @return info文件中添加了对访问摄像头权限的提示
 */
+ (BOOL)hsy_haveOpenCameraAuthoritys;

@end

NS_ASSUME_NONNULL_END
