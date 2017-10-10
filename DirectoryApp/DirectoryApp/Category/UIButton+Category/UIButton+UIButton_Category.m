//
//  UIButton+UIButton_Category.m
//  Ribbn
//
//  Created by Bibin Mathew on 1/23/17.
//  Copyright © 2017 codelynks. All rights reserved.
//

#import "UIButton+UIButton_Category.h"

@implementation UIButton (UIButton_Category)

-(void)addRedGradientView{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    float width = [[UIScreen mainScreen] bounds].size.width;
    gradientLayer.frame = CGRectMake(0, 0, width, self.frame.size.height);
    
    gradientLayer.colors = [NSArray arrayWithObjects:
                            (id)[UIColor redColor].CGColor,
                            (id)[UIColor blueColor].CGColor,
                            nil];
    gradientLayer.cornerRadius = self.layer.cornerRadius;
    [self.layer addSublayer:gradientLayer];
}
@end
