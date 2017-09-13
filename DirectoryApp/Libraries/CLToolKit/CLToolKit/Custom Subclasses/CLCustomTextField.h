//
//  CLTextField.h
//  Colgate
//
//  Created by Vishakh Krishnan on 9/12/13.
//  Copyright (c) 2013 Codelynks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLCustomTextField : UITextField

@property (nonatomic,assign) BOOL preventEdgeInsetLayouting;

- (void)setPlaceHolderFrame:(CGRect ) placeHolderFrame;

@end
