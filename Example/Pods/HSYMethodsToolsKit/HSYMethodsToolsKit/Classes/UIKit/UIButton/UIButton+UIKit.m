//
//  UIButton+UIKit.m
//  HSYMethodsToolsKit
//
//  Created by anmin on 2019/10/15.
//

#import "UIButton+UIKit.h"
#import "ReactiveObjC.h"

@implementation UIButton (UIKit)

+ (instancetype)hsy_buttonWithAction:(void(^)(UIButton *button))action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [[[button rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (action) {
            action((UIButton *)x);
        }
    }];
    
    return button;
}

#pragma mark - Methods

- (void)hsy_setTitle:(NSString *)title
{
    if (title.length) {
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitle:title forState:UIControlStateHighlighted];
    }
}

- (void)hsy_setTitleColor:(UIColor *)color
{
    if (color) {
        [self setTitleColor:color forState:UIControlStateNormal];
        [self setTitleColor:color forState:UIControlStateHighlighted];
    }
}

- (void)hsy_setTitleShadowColor:(UIColor *)color
{
    if (color) {
        [self setTitleShadowColor:color forState:UIControlStateNormal];
        [self setTitleShadowColor:color forState:UIControlStateHighlighted];
    }
}

- (void)hsy_setImage:(UIImage *)image
{
    if (image) {
        [self setImage:image forState:UIControlStateNormal];
        [self setImage:image forState:UIControlStateHighlighted];
    }
}

- (void)hsy_setBackgroundImage:(UIImage *)image
{
    if (image) {
        [self setBackgroundImage:image forState:UIControlStateNormal];
        [self setBackgroundImage:image forState:UIControlStateHighlighted];
    }
}

- (void)hsy_setAttributedTitle:(NSAttributedString *)title
{
    if (title.string.length) {
        [self setAttributedTitle:title forState:UIControlStateNormal];
        [self setAttributedTitle:title forState:UIControlStateHighlighted];
    }
}

@end
