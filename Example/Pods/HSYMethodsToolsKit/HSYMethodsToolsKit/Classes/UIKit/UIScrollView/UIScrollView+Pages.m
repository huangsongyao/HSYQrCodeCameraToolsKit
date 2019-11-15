//
//  UIScrollView+Pages.m
//  HSYMethodsToolsKit
//
//  Created by anmin on 2019/9/29.
//

#import "UIScrollView+Pages.h"
#import "UIView+Frame.h"

@implementation UIScrollView (Pages)

- (NSInteger)hsy_pages
{
    NSInteger pages = self.contentSize.width/self.width;
    return pages;
}

- (NSInteger)hsy_currentPage
{
    NSInteger pages = self.contentSize.width/self.width;
    CGFloat scrollPercent = [self hsy_scrollPercent];
    NSInteger currentPage = (NSInteger)roundf((pages-1) * scrollPercent);
    return currentPage;
}

- (CGFloat)hsy_scrollPercent
{
    CGFloat width = self.contentSize.width - self.width;
    CGFloat scrollPercent = self.contentOffset.x/width;
    return scrollPercent;
}

- (CGFloat)hsy_pagesY
{
    CGFloat pageHeight = self.height;
    CGFloat contentHeight = self.contentSize.height;
    return (contentHeight / pageHeight);
}

- (CGFloat)hsy_pagesX
{
    CGFloat pageWidth = self.width;
    CGFloat contentWidth = self.contentSize.width;
    return (contentWidth / pageWidth);
}

- (CGFloat)hsy_currentPageY
{
    CGFloat pageHeight = self.height;
    CGFloat offsetY = self.contentOffset.y;
    return (offsetY / pageHeight);
}

- (CGFloat)hsy_currentPageX
{
    CGFloat pageWidth = self.width;
    CGFloat offsetX = self.contentOffset.x;
    return (offsetX / pageWidth);
}

- (CGFloat)hsy_contentSizeWidth
{
    return self.contentSize.width;
}

- (CGFloat)hsy_contentSizeHeight
{
    return self.contentSize.height;
}

- (NSArray<UIView *> *)hsy_subViews:(Class)classes
{
    NSMutableArray<UIView *> *views = [[NSMutableArray alloc] init];
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:classes]) {
            [views addObject:view];
        }
    }
    return views;
}

- (void)hsy_setYPage:(NSInteger)page
{
    [self hsy_setYPage:page animated:NO];
}

- (void)hsy_setXPage:(NSInteger)page
{
    [self hsy_setXPage:page animated:NO];
}

- (void)hsy_setYPage:(NSInteger)page animated:(BOOL)animated
{
    CGFloat pageHeight = self.height;
    CGFloat offsetY = page * pageHeight;
    CGFloat offsetX = self.contentOffset.x;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    [self setContentOffset:offset animated:animated];
}

- (void)hsy_setXPage:(NSInteger)page animated:(BOOL)animated
{
    CGFloat pageWidth = self.width;
    CGFloat offsetY = self.contentOffset.y;
    CGFloat offsetX = page * pageWidth;
    CGPoint offset = CGPointMake(offsetX,offsetY);
    [self setContentOffset:offset animated:animated];
}

- (kHSYCocoaKitScrollDirection)hsy_scrollHorizontalDirection
{
    CGPoint point =  [self.panGestureRecognizer translationInView:self.superview];
    return (point.x < 0.0f ? kHSYCocoaKitScrollDirectionToRight : kHSYCocoaKitScrollDirectionToLeft);
}

- (kHSYCocoaKitScrollDirection)hsy_scrollVerticalDirection
{
    CGPoint point =  [self.panGestureRecognizer translationInView:self.superview];
    return (point.y > 0.0f ? kHSYCocoaKitScrollDirectionToUp : kHSYCocoaKitScrollDirectionToDown);
}


@end
