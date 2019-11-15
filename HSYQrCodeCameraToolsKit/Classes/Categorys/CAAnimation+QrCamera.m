//
//  CAAnimation+QrCamera.m
//  HSYQrCodeCameraTools
//
//  Created by anmin on 2019/11/13.
//

#import "CAAnimation+QrCamera.h"

@implementation CAAnimation (QrCamera)

+ (CABasicAnimation *)animationByKeyPath:(NSString *)keyPath
                                duration:(NSTimeInterval)duration
                               formValue:(CGFloat)formValue
                                 toValue:(CGFloat)toValue
                     removedOnCompletion:(BOOL)reset
                            autoreverses:(BOOL)autoreverses
                             repeatCount:(NSInteger)count
{
    CABasicAnimation *animation =  [CABasicAnimation animationWithKeyPath:keyPath];
    animation.fromValue = @(formValue);
    animation.toValue = @(toValue);
    animation.duration = duration;
    animation.autoreverses = autoreverses;
    animation.removedOnCompletion = reset;
    if (!reset) {
        animation.fillMode = kCAFillModeForwards;
    }
    animation.repeatCount = count;
    return animation;
}

+ (CABasicAnimation *)translationAnimationForDuration:(NSTimeInterval)duration
                                            formValue:(CGFloat)formValue
                                              toValue:(CGFloat)toValue
                                  removedOnCompletion:(BOOL)reset
                                          repeatCount:(NSInteger)count
                                       timingFunction:(CAMediaTimingFunction *)function
{
    CABasicAnimation *animation = [CABasicAnimation animationByKeyPath:@"transform.translation.y"
                                                              duration:duration
                                                             formValue:formValue
                                                               toValue:toValue
                                                   removedOnCompletion:reset
                                                          autoreverses:NO
                                                           repeatCount:count];
    return animation;
}

+ (void)hsy_qrCameraScaningAnimation:(CGFloat)toValue onLayer:(CALayer *)layer forKey:(NSString *)key
{
    [self.class hsy_removeQrCameraAnimation:key byLayer:layer];
    CAMediaTimingFunction *function = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    CABasicAnimation *animation = [CAAnimation translationAnimationForDuration:2.0f
                                                                     formValue:0
                                                                       toValue:toValue
                                                           removedOnCompletion:YES
                                                                   repeatCount:1000000
                                                                timingFunction:function];
    [layer addAnimation:animation forKey:key];
}

+ (void)hsy_removeQrCameraAnimation:(NSString *)forKey byLayer:(CALayer *)layer
{
    if ([layer.animationKeys containsObject:forKey]) {
        [layer removeAnimationForKey:forKey];
    }
}

@end
