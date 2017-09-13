//
//  UIView+CLAdditions.h
//  CLToolKit
//
//  Created by Vaisakh krishnan on 18 Aug, 2013
//  Copyright (c) 2013 Codelynks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CLAdditions)

- (void)moveUpBy:(CGFloat)value;
- (void)moveDownBy:(CGFloat)value;

- (void)increaseWidthBy:(CGFloat)width;
- (void)decreaseWidthBy:(CGFloat)width;

- (void)increaseHeightBy:(CGFloat)height;
- (void)decreaseHeightBy:(CGFloat)height;

- (CGFloat)x;
- (void)setX:(CGFloat)x;
- (CGFloat)y;
- (void)setY:(CGFloat)y;

- (CGFloat)width;
- (void)setWidth:(CGFloat)width;
- (CGFloat)height;
- (void)setHeight:(CGFloat)height;

- (CGFloat)left;
- (void)setLeft:(CGFloat)left;
- (CGFloat)top;
- (void)setTop:(CGFloat)top;
- (CGFloat)right;
- (void)setRight:(CGFloat)right;
- (CGFloat)bottom;
- (void)setBottom:(CGFloat)bottom;

- (void)centralizeInParent;

- (void)adjustHeightToFit;

- (void)setEmptyView:(UIView *)view;
- (void)setEmptyView:(UIView *)view marginTop:(CGFloat)marginTop;
- (void)setEmptyText:(NSString *)text;
- (void)setEmptyText:(NSString *)text marginTop:(CGFloat)marginTop;
- (void)setEmptyText:(NSString *)text font:(UIFont *)font color:(UIColor *)color marginTop:(CGFloat)marginTop;
- (void)removeEmptyView;

- (void)setGradientBackgroundWithTopColor:(UIColor *)topColor bottomColor:(UIColor *)bottomColor;

- (UIView *)parentWindow;

- (void)show;
- (void)hide;

- (void)fadeIn;
- (void)fadeIn:(NSTimeInterval)animationDuration withOptions:(UIViewAnimationOptions)options;
- (void)fadeOut;
- (void)fadeOut:(NSTimeInterval)animationDuration withOptions:(UIViewAnimationOptions)option;
- (void)toggle;

@end
