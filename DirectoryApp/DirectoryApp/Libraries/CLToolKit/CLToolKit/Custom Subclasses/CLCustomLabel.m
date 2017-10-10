//
//  CLCustomLabel.m
//  Colgate
//
//  Created by Aravind on 9/12/13.
//  Copyright (c) 2013 Codelynks. All rights reserved.
//

#import "CLCustomLabel.h"

@implementation CLCustomLabel

@synthesize textEdgeInset = _textEdgeInset;

- (void)drawTextInRect:(CGRect)rect {
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.textEdgeInset)];
}



@end
