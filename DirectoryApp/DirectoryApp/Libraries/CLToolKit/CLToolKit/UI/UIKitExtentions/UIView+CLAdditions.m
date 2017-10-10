//
//  UIView+L7Additions.m
//  CLToolKit
//
//  Created by Vaisakh krishnan on 18 Aug, 2013
//  Copyright (c) 2013 Codelynks. All rights reserved.
//

#import "UIView+CLAdditions.h"
#import "QuartzCore/QuartzCore.h"

static int const kEmptyViewTag = 3223;

static const float kAnimationDuration = .23;

////////// Private helper class - EmptyViewWrapperView interface ///////////

@interface EmptyViewWrapperView : UIView

@property(nonatomic, assign) CGFloat marginTop;
@property(nonatomic, strong) UIView *childEmptyView;

+ (EmptyViewWrapperView *)wrapperViewForView:(UIView *)view withMarginTop:(CGFloat)marginTop;

@end

/////////////////////////////////////////////////////////////////

@implementation UIView (L7Additions)

#pragma mark - Frame adjustment helpers

- (void)moveUpBy:(CGFloat)value {
    CGRect frame = self.frame;
    frame.origin.y -= value;
    self.frame = frame;
}

- (void)moveDownBy:(CGFloat)value {
    CGRect frame = self.frame;
    frame.origin.y += value;
    self.frame = frame;
}

- (void)increaseWidthBy:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width += width;
    self.frame = frame;
}

- (void)decreaseWidthBy:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width -= width;
    self.frame = frame;
}

- (void)increaseHeightBy:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height += height;
    self.frame = frame;
}

- (void)decreaseHeightBy:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height -= height;
    self.frame = frame;
}

- (void)centralizeInParent {
    UIView *superview = self.superview;
    self.center = CGPointMake(superview.width / 2, superview.height / 2);//CGPointMake(superview.center.x - superview.frame.origin.x, superview.center.y - superview.frame.origin.y);
}

// Adjust the height to extend up to the last row of its largest child
- (void)adjustHeightToFit {
    CGFloat maxHeight = 0;

    for (UIView *view in self.subviews) {
        maxHeight = fmaxf(maxHeight, CGRectGetMaxY(view.frame));
    }

    [self setHeight:maxHeight];
}

#pragma mark -

- (void)setEmptyText:(NSString *)text {
    [self setEmptyText:text font:[UIFont systemFontOfSize:15.0] color:[UIColor lightGrayColor] marginTop:0];
}

- (void)setEmptyText:(NSString *)text marginTop:(CGFloat)marginTop {
    [self setEmptyText:text font:[UIFont systemFontOfSize:15.0] color:[UIColor lightGrayColor] marginTop:marginTop];
}


- (void)setEmptyText:(NSString *)text font:(UIFont *)font color:(UIColor *)color marginTop:(CGFloat)marginTop {
    UILabel *label = [[UILabel alloc] init];
    [label setFont:font];
    [label setTextColor:color];
    [label setBackgroundColor:[UIColor clearColor]];

    label.numberOfLines = 0;
    //label.lineBreakMode = UILineBreakModeWordWrap;
    //label.textAlignment = UITextAlignmentCenter;
    [label setText:text];

    [self setEmptyView:label marginTop:marginTop];
}

- (void)setEmptyView:(UIView *)view {
    [self setEmptyView:view marginTop:0];
}

- (void)setEmptyView:(UIView *)view marginTop:(CGFloat)marginTop {
    UIView *previousEmptyView = [self viewWithTag:kEmptyViewTag];
    if (previousEmptyView) {
        [previousEmptyView removeFromSuperview];
    }

    EmptyViewWrapperView *emptyView = [EmptyViewWrapperView wrapperViewForView:view withMarginTop:marginTop];
    [emptyView setTag:kEmptyViewTag];
    [self addSubview:emptyView];
}

- (void)removeEmptyView {
    UIView *emptyView = [self viewWithTag:kEmptyViewTag];
    if (emptyView) {
        [emptyView removeFromSuperview];
    }
}

#pragma mark -

- (void)setGradientBackgroundWithTopColor:(UIColor *)topColor bottomColor:(UIColor *)bottomColor {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    [gradientLayer setColors:[NSArray arrayWithObjects:
            (id) [topColor CGColor],
            (id) [bottomColor CGColor], nil]];

    gradientLayer.needsDisplayOnBoundsChange = YES;

    // Add a check whether the layer of firstSubView is a gradientLayer. If yes remove it
    CALayer *topLayer = [[self.layer sublayers] objectAtIndex:0];
    if ([topLayer isKindOfClass:[CAGradientLayer class]]) {
        [self.layer replaceSublayer:topLayer with:gradientLayer];
    } else {
        [self.layer insertSublayer:gradientLayer atIndex:0];
    }
}


- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x {
    self.frame = (CGRect) {.origin.x=x, .origin.y=self.frame.origin.y, .size=self.frame.size};
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y {
    self.frame = (CGRect) {.origin.x=self.frame.origin.x, .origin.y=y, .size=self.frame.size};
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    self.frame = (CGRect) {.origin=self.frame.origin, .size.width=width, .size.height=self.frame.size.height};
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    self.frame = (CGRect) {.origin=self.frame.origin, .size.width=self.frame.size.width, .size.height=height};
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)left {
    self.frame = (CGRect) {.origin.x=left, .origin.y=self.frame.origin.y, .size.width=fmaxf(self.frame.origin.x + self.frame.size.width - left, 0), .size.height=self.frame.size.height};
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)top {
    self.frame = (CGRect) {.origin.x=self.frame.origin.x, .origin.y=top, .size.width=self.frame.size.width, .size.height=fmaxf(self.frame.origin.y + self.frame.size.height - top, 0)};
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    self.frame = (CGRect) {.origin=self.frame.origin, .size.width=fmaxf(right - self.frame.origin.x, 0), .size.height=self.frame.size.height};
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    self.frame = (CGRect) {.origin=self.frame.origin, .size.width=self.frame.size.width, .size.height=fmaxf(bottom - self.frame.origin.y, 0)};
}

- (UIView *)parentWindow {
    UIView *view = nil;

    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if ([keyWindow respondsToSelector:@selector(rootViewController)]) {
        //Use the rootViewController to reflect the device orientation
        view = keyWindow.rootViewController.view;
    }
    return view;
}


- (void)show {
    [self setHidden:NO];
}

- (void)hide {
    [self setHidden:YES];
}

#pragma -
- (void)fadeIn {
    [self fadeIn:kAnimationDuration withOptions:UIViewAnimationOptionCurveEaseInOut];
}

- (void)fadeIn:(NSTimeInterval)animationDuration withOptions:(UIViewAnimationOptions)options {
    [self setHidden:NO];
    self.alpha = 0.0;

    [UIView animateWithDuration:animationDuration
                          delay:0
                        options:options
                     animations:^{
                         self.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                     }];
}

- (void)fadeOut {
    [self fadeOut:kAnimationDuration withOptions:UIViewAnimationOptionCurveEaseInOut];
}

- (void)fadeOut:(NSTimeInterval)animationDuration withOptions:(UIViewAnimationOptions)option {
    self.alpha = 1.0;

    [UIView animateWithDuration:animationDuration
                          delay:0
                        options:option
                     animations:^{
                         self.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         [self setHidden:YES];
                     }];
}

- (void)toggle {
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.alpha = self.alpha == 0.0 ? 1.0 : 0.0;
    }];

}

@end

////////// Private helper class - EmptyViewWrapperView implementation ///////////

@implementation EmptyViewWrapperView

@synthesize marginTop = _marginTop;
@synthesize childEmptyView = _childEmptyView;

+ (EmptyViewWrapperView *)wrapperViewForView:(UIView *)view withMarginTop:(CGFloat)marginTop {
    EmptyViewWrapperView *emptyView = [[EmptyViewWrapperView alloc] init];
    emptyView.marginTop = marginTop;
    emptyView.childEmptyView = view;

    [emptyView addSubview:view];

    return emptyView;
}


- (void)layoutSubviews {
    [super layoutSubviews];

    // layout the child
    int const padding = 10 * 2/* both sides*/;
    CGSize childEmptyViewSize = CGSizeMake(MIN(self.superview.width - padding, 500), self.superview.height - padding);
    childEmptyViewSize = [self.childEmptyView sizeThatFits:childEmptyViewSize];
    self.childEmptyView.frame = CGRectMake(0, 0, childEmptyViewSize.width, childEmptyViewSize.height);

    // layout self
    self.bounds = self.childEmptyView.bounds;

    // move to center
    [self centralizeInParent];

    if (self.marginTop > 0) {
        [self setY:self.marginTop];
    } else {
        // Push the view little bit more upwards
        [self setY:self.y - self.height / 2];
    }

    //NSLog(@"self.superview : %@",self.superview);
}

@end

////////////////////////////////////////////////////////////////////

