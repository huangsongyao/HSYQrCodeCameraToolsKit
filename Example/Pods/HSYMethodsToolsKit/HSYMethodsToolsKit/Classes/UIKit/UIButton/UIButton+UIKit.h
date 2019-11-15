//
//  UIButton+UIKit.h
//  HSYMethodsToolsKit
//
//  Created by anmin on 2019/10/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (UIKit)

/**
 快速创建

 @param action action方法
 @return UIButton
 */
+ (instancetype)hsy_buttonWithAction:(void(^)(UIButton *button))action;

/**
 设置title

 @param title title
 */
- (void)hsy_setTitle:(NSString *)title;

/**
 设置title的颜色

 @param color title的颜色
 */
- (void)hsy_setTitleColor:(UIColor *)color;

/**
 设置title的阴影颜色

 @param color title的阴影颜色
 */
- (void)hsy_setTitleShadowColor:(UIColor *)color;

/**
 设置image

 @param image image
 */
- (void)hsy_setImage:(UIImage *)image;

/**
 设置backgroundImage

 @param image backgroundImage
 */
- (void)hsy_setBackgroundImage:(UIImage *)image;

/**
 设置title的富文本

 @param title title的富文本
 */
- (void)hsy_setAttributedTitle:(NSAttributedString *)title;

@end

NS_ASSUME_NONNULL_END
