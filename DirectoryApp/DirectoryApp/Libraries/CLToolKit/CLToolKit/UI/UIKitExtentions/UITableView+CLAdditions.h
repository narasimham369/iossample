//
//  UITableView+CLAdditions.h
//  CLToolKit
//
//  Created by Vishakh Krishnan on 9/24/13.
//  Copyright (c) 2013 Codelynks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (CLAdditions)

- (void)setEmptyHeaderView;
- (void)setEmptyFooterView;
- (void)setFooterViewWithHeight:(CGFloat)height;
- (void)setHeaderViewWithHeight:(CGFloat)height;

@end
