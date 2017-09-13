//
//  UITableView+CLAdditions.m
//  CLToolKit
//
//  Created by Vishakh Krishnan on 9/24/13.
//  Copyright (c) 2013 Codelynks. All rights reserved.
//

#import "UITableView+CLAdditions.h"

@implementation UITableView (CLAdditions)

- (void)setEmptyHeaderView {
    self.tableHeaderView = nil;
}

- (void)setEmptyFooterView {
    self.tableFooterView = nil;
}

- (void)setFooterViewWithHeight:(CGFloat)height {
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, height)];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableFooterView = footerView;
}

- (void)setHeaderViewWithHeight:(CGFloat)height {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, height)];
    headerView.backgroundColor = [UIColor clearColor];
    self.tableHeaderView = headerView;
}

@end
